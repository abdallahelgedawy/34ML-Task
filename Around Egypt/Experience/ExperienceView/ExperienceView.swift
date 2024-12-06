import SwiftUI

struct ExperienceView: View {
    let experienceId: String
    @StateObject private var viewModel: ExperienceViewModel = ExperienceViewModel(likedExperiences: [:])
    @State private var isLiked: Bool = false  // Track if the experience is liked or not
    @State private var isLoading: Bool = true // Loading state to show loading spinner
    @Binding var likedExperiences: [String: Bool]
    private var observer: NSObjectProtocol?
    

        init(experienceId: String, likedExperiences: Binding<[String: Bool]>) {
            self.experienceId = experienceId
            self._likedExperiences = likedExperiences
            self._viewModel = StateObject(wrappedValue: ExperienceViewModel(likedExperiences: likedExperiences.wrappedValue))
        }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                    // Header Section with Cover Photo, Title, and Description
                    ZStack(alignment: .bottomLeading) {
                        // Cover Photo
                        AsyncImage(url: URL(string: viewModel.experience.coverPhoto)) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: 300)
                                .clipped()
                        } placeholder: {
                            Color.gray
                                .frame(height: 300)
                        }

                        // Views Counter - Bottom Left of the Image
                        HStack(spacing: 8) {
                            Image(systemName: "eye")
                                .foregroundColor(.white)

                            Text("\(viewModel.experience.viewsNo) views") // Views from the fetched data
                                .font(.custom("GothamMedium", size: 14))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 10) // Position it at the bottom left
                    }

                    // Explore Now Button Centered Over Image
                    Button(action: {
                        print("Explore Now tapped")
                    }) {
                        Text("EXPLORE NOW")
                            .font(.custom("Gotham-Bold", size: 14))
                            .foregroundColor(.orange)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Center the button
                    .padding(.top, -150) // Adjust vertical positioning if needed

                    // Experience Info Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            // Title - Aligned to the leading edge
                            Text(viewModel.experience.title) // Title from the fetched data
                                .font(.custom("Gotham-Bold", size: 16))
                                .foregroundColor(.black)
                                .accessibilityIdentifier("Experience_\(viewModel.experience.id)") 
                            Spacer()
                            
                            // Share and Like Buttons - Aligned to the trailing edge
                            HStack(spacing: 8) {
                                Button(action: {
                                    print("Share tapped")
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.orange)
                                }
                                
                                // Like Button - Toggled based on the isLiked state
                                Button(action: {
                                   toggleLikeStatus()
                                }) {
                                    Image(systemName: isLiked ? "heart.fill" : "heart")  // Change the icon based on the like state
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.orange)
                                }

                                // Number of Likes
                                Text("\(viewModel.experience.likesNo)")  // Show number of likes
                                    .font(.custom("Gotham-Bold", size: 14))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal)

                        Divider()

                        // Description Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Gotham-Bold", size: 18))
                                .foregroundColor(.black)

                            Text(viewModel.experience.description) // Description from the fetched data
                                .font(.custom("GothamMedium", size: 14))
                                .foregroundColor(.black)
                                .lineSpacing(10)
                                .padding(.bottom) // Ensure there's space at the bottom
                        }
                        .padding(.horizontal)
                    }
                }
            .padding(.bottom, 16)
        }
        .onAppear {
            viewModel.fetchExperienceByID(id: experienceId) {
                isLoading = false // Set loading to false when data is loaded
            }
            print("Exper",viewModel.experience)
            syncLikeState()  // Check if the experience has been liked
        }.onDisappear{
            if let observer = observer {
                        NotificationCenter.default.removeObserver(observer)
                    }
        }
        .navigationTitle("Experience Screen").accessibilityIdentifier("Experience Detail")
        .navigationBarTitleDisplayMode(.inline)
    }

    // This method checks if the experience has been liked by looking up the ID in the likedExperiences dictionary
    private func syncLikeState() {
            // Sync local isLiked state with the shared likedExperiences
            isLiked = likedExperiences[experienceId] ?? false
        }

    // This method toggles the like status and persists it
    private func toggleLikeStatus() {
            if !isLiked {
                // Only allow liking once
                isLiked = true

                // Update the shared likedExperiences dictionary
                likedExperiences[experienceId] = true

                // Update the ViewModel and UserDefaults
                viewModel.updateLikeStatus(for: experienceId, isLiked: true)

                // Post a notification to update other views if necessary
                NotificationCenter.default.post(name: .experienceLikeStatusChanged, object: nil, userInfo: ["experienceId": experienceId, "isLiked": true])
            }
        }
}

//struct ExperienceView_Previews: PreviewProvider {
//    static var previews: some View {
//     //   ExperienceView(experienceId: "7f209d18-36a1-44d5-a0ed-b7eddfad48d6", likedExperiences: ["7f209d18-36a1-44d5-a0ed-b7eddfad48d6": true])
//    }
//}
