//
//  NetworkService.swift
//  Around Egypt
//
//  Created by Abdallah Elgedawy on 05/12/2024.
//

import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchRecommendedExperiences(completion: @escaping (Result<[Experience], Error>) -> Void) {
        let endpoint = "\(Constant.base_URL)api/v2/experiences?filter[recommended]=true"
        
        AF.request(endpoint)
                 .validate()
                 .responseDecodable(of: ExperiencesResponse.self) { response in
                     switch response.result {
                     case .success(let data):
                         // Successfully decoded the response
                         print("Decoded Data: \(data)")
                         // Extract the 'data' array and pass it to completion handler
                         completion(.success(data.data)) // Passing the array of experiences
                         
                     case .failure(let error):
                         // Failure in decoding the response
                         print("Error: \(error.localizedDescription)")
                         // Print the response data for debugging
                         if let data = response.data {
                             print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                         }
                         completion(.failure(error)) // Return the error
                     }
                 }
    }
    func fetchMostRecentExperiences(completion: @escaping (Result<[Experience], Error>) -> Void) {
        let endpoint = "\(Constant.base_URL)api/v2/experiences"
        
        AF.request(endpoint)
                 .validate()
                 .responseDecodable(of: ExperiencesResponse.self) { response in
                     switch response.result {
                     case .success(let data):
                         // Successfully decoded the response
                         print("Decoded Data: \(data)")
                         // Extract the 'data' array and pass it to completion handler
                         completion(.success(data.data)) // Passing the array of experiences
                         
                     case .failure(let error):
                         // Failure in decoding the response
                         print("Error: \(error.localizedDescription)")
                         // Print the response data for debugging
                         if let data = response.data {
                             print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                         }
                         completion(.failure(error)) // Return the error
                     }
                 }
    }
    
    func likeExperience(experienceID: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let endpoint = "\(Constant.base_URL)api/v2/experiences/\(experienceID)/like"
        
        AF.request(endpoint, method: .post)
            .responseDecodable(of: LikeResponse.self) { response in
                switch response.result {
                case .success(let data):
                    // Success: Pass the updated like count to the completion handler
                    completion(.success(data.data))
                case .failure(let error):
                    // Failure: Handle errors
                    if let responseData = response.data,
                       let message = String(data: responseData, encoding: .utf8) {
                        print("Error: \(message)")
                    }
                    completion(.failure(error))
                }
            }
    }
    
    func fetchExperiencesBySearch(searchText:String,completion: @escaping (Result<[Experience], Error>) -> Void) {
        let endpoint = "\(Constant.base_URL)api/v2/experiences?filter[title]=\(searchText)"
        
        AF.request(endpoint)
                 .validate()
                 .responseDecodable(of: ExperiencesResponse.self) { response in
                     switch response.result {
                     case .success(let data):
                         // Successfully decoded the response
                         print("Decoded Data: \(data)")
                         // Extract the 'data' array and pass it to completion handler
                         completion(.success(data.data)) // Passing the array of experiences
                         
                     case .failure(let error):
                         // Failure in decoding the response
                         print("Error: \(error.localizedDescription)")
                         // Print the response data for debugging
                         if let data = response.data {
                             print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                         }
                         completion(.failure(error)) // Return the error
                     }
                 }
    }
    
    func fetchExperienceByID(id: String, completion: @escaping (Result<ExperienceDetail, Error>) -> Void) {
        let endpoint = "\(Constant.base_URL)api/v2/experiences/\(id)"
        
        AF.request(endpoint)
            .validate()
            .responseDecodable(of: ExperienceDetailResponse.self) { response in
                switch response.result {
                case .success(let data):
                    // Successfully decoded the response
                    print("Decoded Data: \(data)")
                    
                    // Check if the response contains at least one experience
                    completion(.success(data.data)) // Return the first (or only) experience                    
                case .failure(let error):
                    // Handle decoding or network errors
                    print("Error: \(error.localizedDescription)")
                    if let data = response.data {
                        print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
                    }
                    completion(.failure(error)) // Return the error
                }
            }
    }

}


