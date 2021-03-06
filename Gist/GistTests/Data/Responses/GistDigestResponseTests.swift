import Foundation
import XCTest

@testable import Gist

final class GistDigestResponseTests: XCTestCase {

    func test_onDecoding_withAllFieldsAbsent_shouldReturnTheObjectWithNilValues() {
        let json = "{}"

        let actualValue: GistDigestResponse? = json.decode()

        XCTAssertNotNil(actualValue)
        XCTAssertNil(actualValue?.description)
        XCTAssertNil(actualValue?.createdAt)
        XCTAssertNil(actualValue?.files)
        XCTAssertNil(actualValue?.owner)
    }

    func test_onDecoding_withInvalidJson_shouldReturnTheObjectWithNilValues() {
        let json = String.anyValue

        let actualValue: GistDigestResponse? = json.decode()

        XCTAssertNil(actualValue)
    }

    func test_onDecoding_withValidJson_shouldParseTheObject() {
        let json = """
        {
            "id": "aa5a315d61ae9438b18d",
            "non-expected": null,
            "description": "Hello World Examples",
            "created_at": "any value",
            "files": {
                "hello_world.rb": {
                    "filename": "hello_world.rb",
                    "type": "application/x-ruby",
                    "language": "Ruby",
                    "raw_url": "https://gist.githubusercontent.com/octocat/6cad326836d38bd3a7ae/raw/db9c55113504e46fa076e7df3a04ce592e2e86d8/hello_world.rb",
                    "size": 167
                }
            },
            "owner": {
                "login": "octocat",
                "id": 1,
                "node_id": "MDQ6VXNlcjE=",
                "avatar_url": "https://github.com/images/error/octocat_happy.gif",
                "gravatar_id": "",
                "url": "https://api.github.com/users/octocat",
                "html_url": "https://github.com/octocat",
                "followers_url": "https://api.github.com/users/octocat/followers",
                "following_url": "https://api.github.com/users/octocat/following{/other_user}",
                "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
                "organizations_url": "https://api.github.com/users/octocat/orgs",
                "repos_url": "https://api.github.com/users/octocat/repos",
                "events_url": "https://api.github.com/users/octocat/events{/privacy}",
                "received_events_url": "https://api.github.com/users/octocat/received_events",
                "type": "User",
                "site_admin": false
            }
        }
        """

        let actualValue: GistDigestResponse? = json.decode()
        let actualFile = actualValue?.files?["hello_world.rb"]

        XCTAssertNotNil(actualValue)
        XCTAssertEqual(actualValue?.description, "Hello World Examples")
        XCTAssertEqual(actualValue?.createdAt, "any value")
        XCTAssertEqual(actualFile?.filename, "hello_world.rb")
        XCTAssertEqual(actualFile?.type, "application/x-ruby")
        XCTAssertEqual(actualValue?.owner?.login, "octocat")
        XCTAssertEqual(actualValue?.owner?.avatarUrl, "https://github.com/images/error/octocat_happy.gif")
    }
}

extension String {
    func decode<T: Codable>() -> T? {
        let decoder = JSONDecoder()
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
        }
        return nil
    }
}
