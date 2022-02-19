import Foundation

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
