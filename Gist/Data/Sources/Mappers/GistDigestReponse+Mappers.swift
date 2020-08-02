import Foundation

extension GistDigestResponse {
    init(gist: GistDigest) {
        self.id = gist.id
        self.createdAt = gist.createdAt
        self.description = gist.description
        self.owner = Owner(owner: gist.owner)
        let files = gist.files.map(File.init)
        self.files = files.reduce([String: File]()) { (dict, file) -> [String: File] in
            var dict = dict
            if let filename = file.filename {
                dict[filename] = file
            }

            return dict
        }
    }
}

extension GistDigestResponse.Owner {
    init(owner: GistDigest.Owner) {
        self.login = owner.name
        self.avatarUrl = owner.avatarUrl?.absoluteString
    }
}

extension GistDigestResponse.File {
    init(file: GistDigest.File) {
        self.filename = file.name
        self.type = file.type
    }
}
