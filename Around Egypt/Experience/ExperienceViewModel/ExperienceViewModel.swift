import Foundation

class ExperienceViewModel: ObservableObject {
    @Published var experience: ExperienceDetail
    @Published var likedExperiences: [String: Bool] // Tracks liked experiences
    
    private let coreDataStack = CoreDataStack.shared
    private let networkMonitor = NetworkMonitor()

    // Initialize with likedExperiences passed from HomeViewModel
    init(likedExperiences: [String: Bool]) {
        self.likedExperiences = likedExperiences
        self.experience = ExperienceDetail(id: "", title: "", coverPhoto: "", description: "", viewsNo: 0, likesNo: 0, recommended: 0)
    }

    func fetchExperienceByID(id: String, completion: @escaping () -> Void) {
        if networkMonitor.isConnected {
            // Fetch from network if connected
            NetworkService.shared.fetchExperienceByID(id: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let experience):
                        print("Dataaaa:",experience)
                        self?.experience = experience
                        self?.saveExperienceToCoreData(experience) // Save experience to Core Data
                        completion()
                    case .failure(let error):
                        print("Failed to fetch experience with ID \(id): \(error)")
                    }
                }
            }
        } else {
            // Load from Core Data if not connected
            if let savedExperience = coreDataStack.fetchExperienceDetail(withID: id) {
                self.experience = ExperienceDetail(id: savedExperience.id ?? "",
                                                   title: savedExperience.title ?? "",
                                                   coverPhoto: savedExperience.cover ?? "",
                                                   description: savedExperience.descriptionText ?? "",
                                                   viewsNo: Int(savedExperience.views),
                                                   likesNo: Int(savedExperience.likes),
                                                   recommended: Int(savedExperience.recommended))
            }
        }
    }

    // Save experience to Core Data
    private func saveExperienceToCoreData(_ experience: ExperienceDetail) {
        coreDataStack.clearExperienceDetail(withID: experience.id) // Clear old data to avoid duplication
        coreDataStack.saveExperienceDetail(experience: experience)
    }

    // Toggle like status and update the count
    func updateLikeStatus(for experienceId: String, isLiked: Bool) {
        // Update the local likedExperiences dictionary
        likedExperiences[experienceId] = isLiked
        
        // Update the like count locally (optimistic UI update)
        experience.likesNo += isLiked ? 1 : -1
        
        // Save the updated likedExperiences to UserDefaults
        saveLikedExperiences()
        
        // Save the updated experience to Core Data
        saveExperienceToCoreData(experience)
        
        // Notify the backend of the updated like status
        NetworkService.shared.likeExperience(experienceID: experienceId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedLikesCount):
                    // Update the like count with the server's response
                    self.experience.likesNo = updatedLikesCount
                    self.saveExperienceToCoreData(self.experience)
                case .failure(let error):
                    print("Failed to update like status on the server: \(error.localizedDescription)")
                    // Optionally, revert the optimistic update on failure
                    self.likedExperiences[experienceId] = !isLiked
                    self.experience.likesNo -= isLiked ? 1 : -1
                    self.saveLikedExperiences()
                }
            }
        }
    }
    private func saveLikedExperiences() {
            UserDefaults.standard.set(likedExperiences, forKey: "likedExperiences")
        }


}
