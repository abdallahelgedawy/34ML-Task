//
//  HomeViewModel.swift
//  Around Egypt
//
//  Created by Abdallah Elgedawy on 05/12/2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var recommendedExperiences: [Experience] = []
    @Published var recentExperiences: [Experience] = []
    @Published var searchResults: [Experience] = []
    
    private let coreDataStack = CoreDataStack.shared
    private let networkMonitor = NetworkMonitor()
    @Published var likedExperiences: [String: Bool] = [:]
        
        
        init() {
            loadLikedExperiences()
        }
        
        // Method to load the liked experiences from UserDefaults
         func loadLikedExperiences() {
            if let savedLikes = UserDefaults.standard.object(forKey: "likedExperiences") as? [String: Bool] {
                likedExperiences = savedLikes
            }
        }
        
        // Method to save the liked experiences to UserDefaults
        private func saveLikedExperiences() {
            UserDefaults.standard.set(likedExperiences, forKey: "likedExperiences")
        }
        
        // Toggle like state for an experience
    func likeExperience(experience: Experience) {
        // Check if the experience is already liked
        if likedExperiences[experience.id] == true {
            print("Experience already liked")
            return // Do nothing if already liked
        }

        // Mark the experience as liked locally
        likedExperiences[experience.id] = true
        saveLikedExperiences() // Save the updated state

        // Call the network to update the likes count
        NetworkService.shared.likeExperience(experienceID: experience.id) { result in
            switch result {
            case .success(let updatedLikesCount):
                // Update the local count with the result from the server
                if let index = self.recommendedExperiences.firstIndex(where: { $0.id == experience.id }) {
                    self.recommendedExperiences[index].likesNo = updatedLikesCount
                }
                if let index = self.recentExperiences.firstIndex(where: { $0.id == experience.id }) {
                    self.recentExperiences[index].likesNo = updatedLikesCount
                }
                if let index = self.searchResults.firstIndex(where: {$0.id == experience.id}){
                    self.searchResults[index].likesNo = updatedLikesCount
                }
            case .failure(let error):
                print("Failed to like experience: \(error.localizedDescription)")
            }
        }
    }


    
    func fetchBySearchExperiences(searchText: String) {
        NetworkService.shared.fetchExperiencesBySearch(searchText: searchText, completion:{ [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let experiences):
                        self?.searchResults = experiences
                    case .failure(let error):
                        print("Network error:", error)
                    }
                }
            })
    }



    func fetchRecommendedExperiences() {
        if networkMonitor.isConnected {
            NetworkService.shared.fetchRecommendedExperiences { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let experiences):
                        self?.recommendedExperiences = experiences
                        self?.saveExperiencesToCoreData(experiences, type: "recommended")
                    case .failure(let error):
                        print("Network error:", error)
                    }
                }
            }
        } else {
            recommendedExperiences = loadExperiencesFromCoreData(ofType: "recommended")
        }
    }

    func fetchMostRecentExperiences() {
        if networkMonitor.isConnected {
            NetworkService.shared.fetchMostRecentExperiences { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let experiences):
                        self?.recentExperiences = experiences
                        self?.saveExperiencesToCoreData(experiences, type: "recent")
                    case .failure(let error):
                        print("Network error:", error)
                    }
                }
            }
        } else {
            recentExperiences = loadExperiencesFromCoreData(ofType: "recent")
        }
    }

    private func saveExperiencesToCoreData(_ experiences: [Experience], type: String) {
        print("DataSaved")
        coreDataStack.clearExperiences(ofType: type) // Clear old data to avoid duplication
        experiences.forEach { coreDataStack.saveExperience(experience: $0, type: type) }
    }

    private func loadExperiencesFromCoreData(ofType type: String) -> [Experience] {
        let savedExperiences = coreDataStack.fetchExperiences(ofType: type)
        return savedExperiences.map {
            Experience(id: $0.id ?? "",
                       title: $0.title ?? "",
                       coverPhoto: $0.cover ?? "",
                       description: "",
                       viewsNo: Int($0.views), likesNo: Int($0.likes), recommended: Int($0.recommended), hasVideo: 0
            )
        }
    }
}
