import Foundation

// Root response
struct ExperiencesResponse: Decodable {
    let meta: Meta
    let data: [Experience]
}

struct Meta: Decodable {
    let code: Int
    let errors: [String]
}

// Experience model
struct Experience: Decodable, Identifiable , Equatable {
    var id: String
    var title: String
    var coverPhoto: String
    var description: String
    var viewsNo: Int
    var likesNo: Int
    var recommended: Int
    var hasVideo: Int
    

    enum CodingKeys: String, CodingKey {
        case id, title, description
        case coverPhoto = "cover_photo"
        case viewsNo = "views_no"
        case likesNo = "likes_no"
        case recommended
        case hasVideo = "has_video"
    }
}

