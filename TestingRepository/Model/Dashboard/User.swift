import Foundation

struct User: Codable {
    var id: String?
    var revision: Int?
    var displayName: String?
    var avatarImageUrl: String?
    var avatarImageBg: String?
    var followers: Int?
    var following: Int?
    var stories: Int?
    var collections: [Collection]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case revision = "revision"
        case displayName = "display_name"
        case avatarImageUrl = "avatar_image_url"
        case avatarImageBg = "avatar_image_bg"
        case followers = "followers"
        case following = "following"
        case stories = "stories"
        case collections = "collections"
    }
}
