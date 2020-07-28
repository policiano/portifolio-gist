import Foundation

struct GistDigestResponse: Codable {
    let description: String?
    let owner: Owner?
    let files: [String: File]

    enum Key: String, CodingKey {
        case description
        case owner
        case files
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
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
        let login: String? //"login": "octocat",
        let avatarUrl: String? //"avatar_url": "https://github.com/images/error/octocat_happy.gif",

        enum CodingKeys: String, CodingKey {
            case login
            case avatarUrl = "avatar_url"
        }
    }
}
