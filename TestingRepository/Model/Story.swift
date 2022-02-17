import Foundation

struct Story: Codable {
    var data: [StoryData]
}

struct StoryData: Codable {
    var id: String?
    var revision: Int?
    var user: User?
}

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

struct Collection: Codable {
    var id: String?
    var name: String?
    var coverImageUrl: String?
    var coverImageBg: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case coverImageUrl = "cover_image_url"
        case coverImageBg = "cover_image_bg"
    }
}
