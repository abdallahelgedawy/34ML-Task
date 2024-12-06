//
//  ExperienceDetailModel.swift
//  Around Egypt
//
//  Created by Abdallah Elgedawy on 06/12/2024.
//

import Foundation


struct ExperienceDetail: Decodable {
    var id: String
    var title: String
    var coverPhoto: String
    var description: String
    var viewsNo: Int
    var likesNo: Int
    var recommended: Int
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case coverPhoto = "cover_photo"
        case viewsNo = "views_no"
        case likesNo = "likes_no"
        case recommended
    }
}

struct ExperienceDetailResponse: Decodable {
    var meta: Meta
    var data: ExperienceDetail
    var pagination: [String: String]?
}


