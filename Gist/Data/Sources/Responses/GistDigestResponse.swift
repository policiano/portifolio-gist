import Foundation

struct GistDigestResponse: Codable {
    let id: String?
    let description: String?
    let owner: Owner?
    let files: [String: File]

    enum Key: String, CodingKey {
        case id
        case description
        case owner
        case files
    }

    init(
        id: String?,
        description: String?,
        owner: Owner?,
        files: [String: File]
    ) {
        self.id = id
        self.description = description
        self.owner = owner
        self.files = files
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.id = try? container.decode(String.self, forKey: .id)
        self.description = try? container.decode(String.self, forKey: .description)
        self.owner = try? container.decode(Owner.self, forKey: .owner)
        self.files = (try? container.decode([String: File].self, forKey: .files)) ?? [:]
    }
}

extension GistDigestResponse {
    struct File: Codable {
        let filename: String?
        let type: String?
    }
}

extension GistDigestResponse {
    struct Owner: Codable {
        let login: String?
        let avatarUrl: String?

        enum CodingKeys: String, CodingKey {
            case login
            case avatarUrl = "avatar_url"
        }
    }
}
