//
//  LikeResponse.swift
//  Around Egypt
//
//  Created by Abdallah Elgedawy on 06/12/2024.
//

import Foundation

struct LikeResponse: Decodable {
    let meta: Meta
    let data: Int // This should be an integer, as it represents the likes count
    let pagination: [String: String]? // This can be an optional dictionary, as we are not sure of the structure of pagination
}

