import Foundation

extension GistDigest {
    convenience init?(response: GistDigestResponse) {
        let files = (response.files ?? [:]).map()
        guard let id = response.id,
            let createdAt = response.createdAt,
            let owner = Owner(response: response.owner),
            !files.isEmpty else {
                return nil
        }
        let description = response.description ?? ""

        let htmlString = "<script src=\"https://gist.github.com/\(owner.name)/\(id).js\"></script>"

        self.init(
            id: id,
            createdAt: createdAt,
            description: description.isEmpty ? nil : description,
            owner: owner,
            files: files,
            bookmarkedAt: nil,
            snippetPath: htmlString
        )
    }
}

extension GistDigest.Owner {
    init?(response: GistDigestResponse.Owner?) {
        guard let login = response?.login else { return nil }

        let url = URL(string: response?.avatarUrl ?? "")
        self.init(name: login, avatarUrl: url)
    }
}

extension GistDigest.File {
    init?(response: GistDigestResponse.File) {
        guard let fileName = response.filename, let type = response.type else {
            return nil
        }

        self.init(name: fileName, type: type)
    }
}

extension Dictionary where Key == String, Value == GistDigestResponse.File {
    func map() -> [GistDigest.File] {
        Array(values).compactMap(GistDigest.File.init)
    }
}
