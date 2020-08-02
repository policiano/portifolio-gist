import Foundation
import CodableFirebase
import FirebaseDatabase

public protocol DatabaseDataSource {
    func set<T: Encodable>(_ data: T, withId id: String, forKey key: String) throws
    func deleteData(withId id: String, forKey key: String)
    func getAll<T: Decodable>(forKey key: String, completion: @escaping (Result<[T]>) -> Void)
}

public class DatabaseUtils {
    private static var database: Database?
    public static var shared: Database {
        if let database = database {
            return database
        }

        let newDatabase = Database.database()
        newDatabase.isPersistenceEnabled = true
        database = newDatabase
        
        return newDatabase
    }
}

public final class FirebaseDataSource {
    private let database: FirebaseDatabase.Database
    private let userDefaults: UserDefaults
    private var storedData: [FirebaseReference] = []


    public init(userDefaults: UserDefaults = .standard, database: Database = DatabaseUtils.shared) {
        self.userDefaults = userDefaults
        self.database = database
    }

    var usersReference: DatabaseReference {
        database.reference().child("user")
    }
}

extension FirebaseDataSource: DatabaseDataSource {
    public func deleteData(withId id: String, forKey key: String) {
        guard let userId = userDefaults.userId else {
            return
        }

        usersReference.child(userId).child(key).child(id).removeValue()
    }

    public func set<T>(_ data: T, withId id: String, forKey key: String) throws where T : Encodable {
        let data = try FirebaseEncoder().encode(data)

        let user: DatabaseReference

        if let userId = userDefaults.userId {
            user = usersReference.child(userId)
        } else {
            user = usersReference.childByAutoId()
            userDefaults.userId = user.key
        }

        user.child(key).child(id).setValue(data)
    }

    public func getAll<T>(forKey key: String, completion: @escaping (Result<[T]>) -> Void) where T : Decodable {

        guard let userId = userDefaults.userId else {
            return completion(.success([]))
        }
        let user = usersReference
            .child(userId)
        user.keepSynced(true)

        user.child(key)
            .observeSingleEvent(of: .value) { snapshot in
                guard let dict = snapshot.value as? [String: Any]  else {
                    return completion(.success([]))
                }

                do {
                    let values = try Array(dict.values).map {
                        try FirebaseDecoder().decode(T.self, from: $0)
                    }
                    completion(.success(values))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}

struct FirebaseReference {
    let key: String
    let domainId: String
}

private extension UserDefaults {
    var userId: String? {
        get { self.string(forKey: "user") }
        set { set(newValue, forKey: "user") }
    }
}
