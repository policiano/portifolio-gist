import Foundation

extension GistDigest {
    init?(response: GistDigestResponse) {
        let files = response.files.map()
        guard let id = response.id,
            let owner = Owner(response: response.owner),
            !files.isEmpty else {
                return nil
        }

        self.init(
            id: id,
            description: response.description,
            owner: owner,
            files: files
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