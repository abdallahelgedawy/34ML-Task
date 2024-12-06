//
//  ContentView.swift
//  Around Egypt
//
//  Created by Abdallah Elgedawy on 03/12/2024.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Conditional Content
                if isSearching {
                    SearchResultsView(viewModel: viewModel)
                } else {
                    MainContentView(viewModel: viewModel)
                }
            }.onReceive(NotificationCenter.default.publisher(for: .experienceLikeStatusChanged)) { notification in
                viewModel.fetchRecommendedExperiences()
                viewModel.fetchMostRecentExperiences()
                viewModel.loadLikedExperiences()
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.fetchRecommendedExperiences()
                viewModel.fetchMostRecentExperiences()
                viewModel.loadLikedExperiences()
            }
            .toolbar {
                // Menu Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Menu tapped")
                    }) {
                        Image("Menu")
                    }
                }

                // Search Bar
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("Search")
                        TextField("", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(Color(hex: "8E8E93"))
                            .submitLabel(.search)
                            .accessibilityIdentifier("SearchForExperiences")
                            .onChange(of: searchText) { newValue in
                                if newValue.isEmpty {
                                    // Exit search state when searchText is cleared
                                    isSearching = false
                                    viewModel.fetchRecommendedExperiences()
                                    viewModel.fetchMostRecentExperiences()
                                }
                            }

                            .onSubmit {
                                if searchText.isEmpty{
                                    isSearching = false
                                    viewModel.fetchRecommendedExperiences()
                                    viewModel.fetchMostRecentExperiences()
                                }else{
                                    isSearching = true
                                    viewModel.fetchBySearchExperiences(searchText: searchText)
                                }
                            }
                            .placeholder(when: searchText.isEmpty) {
                                Text("Try \"Luxor\"")
                                    .foregroundColor(Color(hex: "8E8E93"))
                                    .font(.custom("GothamMedium", size: 14))
                            }
                    }
                    .padding(.horizontal)
                    .frame(height: 36)
                    .background(Color(hex: "8E8E93").opacity(0.12))
                    .cornerRadius(8)
                }

                // Settings Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Settings tapped")
                    }) {
                        Image("Object") // Settings icon
                            .font(.title2)
                    }
                }
            }
        }
    }
}
struct MainContentView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedExperience: Experience? // Track the selected experience
    @State private var isSheetPresented = false
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Welcome Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Welcome!")
                    .font(.custom("GothamRounded-Bold", size: 22))
                    .foregroundColor(.black)
                    .accessibilityIdentifier("Welcome")
                Text("Now you can explore any experience in 360 degrees and get all the details about it all in one place.")
                    .font(.custom("GothamMedium", size: 14))
                    .foregroundColor(.black)
            }
            .padding(.all)

            // Recommended Experiences Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Recommended Experiences")
                    .font(.custom("Gotham-Bold", size: 22))
                    .padding(.horizontal)
                    .foregroundColor(.black)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.recommendedExperiences) { experience in
                            ExperienceCard(experience: experience, viewModel: viewModel)
                                .frame(width: UIScreen.main.bounds.width * 0.9).onTapGesture {
                                    // Set selected experience and present the sheet
                                    print("Tapped on experience: \(experience.title)")
                                    selectedExperience = experience
                                    isSheetPresented = true
                                }

                        }
                    }
                    .padding(.all)
                }
            }

            // Most Recent Section
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Most Recent")
                        .font(.custom("Gotham-Bold", size: 22))
                        .padding(.horizontal)
                        .foregroundColor(.black)

                    VStack(spacing: 15) {
                        ForEach(viewModel.recentExperiences) { experience in
                            RecentExperienceCard(experience: experience, viewModel: viewModel)
                                .frame(width: UIScreen.main.bounds.width * 0.9).onTapGesture {
                                    // Set selected experience and present the sheet
                                    print("Tapped on experience: \(experience.title)")
                                    selectedExperience = experience
                                    isSheetPresented = true
                                }

                            
                        }
                    }
                    .padding(.all)
                }
            }
        }.sheet(isPresented: $isSheetPresented) {
            if let selectedExperience = selectedExperience {
                ExperienceView(experienceId: selectedExperience.id , likedExperiences: $viewModel.likedExperiences)
            }
        }.id(selectedExperience?.id)
    }
}


struct ExperienceCard: View {
    let experience: Experience
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                // Background Image
                AsyncImage(url: URL(string: experience.coverPhoto)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                        .clipped()
                        .cornerRadius(10)
                } placeholder: {
                    Color.gray
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                        .cornerRadius(10)
                }

                // Overlays
                // Top-left: Recommended
                if experience.recommended == 1 {
                    VStack {
                        HStack{
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(hex: "F18757"))
                                .frame(width: 10, height: 10)
                            Text("RECOMMENDED")
                                .font(.custom("GothamMedium", size: 10))

                        }
                        .padding(5)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .padding(.leading, 10)
                        .padding(.top, 10)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Top-right: Info Icon
                VStack {
                        Image("Shape Copy")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                            .padding(.top, 10)

                        Spacer()
                } .frame(maxWidth: .infinity, alignment: .trailing)
                VStack {
                    Spacer()
                    HStack{
                        Image("Shape")
                        Text("\(experience.viewsNo)")
                            .font(.custom("GothamMedium", size: 12))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.vertical,10)
                        Spacer()
                    }.padding(.horizontal)
                }


                // Bottom-right: Album Icon
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("multiple pictures")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                }

                // Center: 360 Icon
                VStack {
                    Spacer()
                    Image("360")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.black.opacity(0.6)))
                        .padding()
                    Spacer()
                }
            }

            // Title and Likes
            HStack {
                Text(experience.title)
                    .font(.custom("Gotham-Bold", size: 14))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.black)
                    .accessibilityIdentifier("Experience_\(experience.id)") 

                Spacer()

                HStack {
                    Text("\(experience.likesNo)")
                        .font(.custom("GothamMedium", size: 14))
                        .foregroundColor(.black)
                        .accessibilityIdentifier("LikeCount")
                    Image(systemName: viewModel.likedExperiences[experience.id] == true ? "heart.fill" : "heart")
                                            .foregroundColor(viewModel.likedExperiences[experience.id] == true ? Color(hex: "#F18757") : .gray)
                                            .accessibilityIdentifier("Like")
                                            .onTapGesture {
                                                // Call the like function to toggle like state
                                                viewModel.likeExperience(experience: experience)
                                            }

                }
            }
            .padding(.horizontal)
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

struct SearchResultsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedExperience: Experience? // Track the selected experience
    @State private var isSheetPresented = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(viewModel.searchResults) { experience in
                    ExperienceCard(experience: experience, viewModel: viewModel)
                        .padding(.horizontal).onTapGesture {
                            // Set selected experience and present the sheet
                            print("Tapped on experience: \(experience.title)")
                            selectedExperience = experience
                            isSheetPresented = true
                        }

                }
            }
            .padding(.top, 10)
        }.sheet(isPresented: $isSheetPresented) {
            if let selectedExperience = selectedExperience {
                ExperienceView(experienceId: selectedExperience.id , likedExperiences: $viewModel.likedExperiences)
            }
        }.id(selectedExperience?.id)
    }
}

struct RecentExperienceCard: View {
    let experience: Experience
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                // Background Image
                AsyncImage(url: URL(string: experience.coverPhoto)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                        .clipped()
                        .cornerRadius(10)
                } placeholder: {
                    Color.gray
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                        .cornerRadius(10)
                }


                // Top-right: Info Icon
                VStack {
                        Image("Shape Copy")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(.trailing, 10)
                            .padding(.top, 10)

                        Spacer()
                } .frame(maxWidth: .infinity, alignment: .trailing)
                VStack {
                    Spacer()
                    HStack{
                        Image("Shape")
                        Text("\(experience.viewsNo)")
                            .font(.custom("GothamMedium", size: 12))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.vertical,10)
                        Spacer()
                    }.padding(.horizontal)
                }


                // Bottom-right: Album Icon
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("multiple pictures")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                }

                // Center: 360 Icon
                VStack {
                    Spacer()
                    Image("360")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.black.opacity(0.6)))
                        .padding()
                    Spacer()
                }
            }

            // Title and Likes
            HStack {
                Text(experience.title)
                    .font(.custom("Gotham-Bold", size: 14))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.black)

                Spacer()

                HStack {
                    Text("\(experience.likesNo)")
                        .font(.custom("GothamMedium", size: 14))
                        .foregroundColor(.black)
                    Image(systemName: viewModel.likedExperiences[experience.id] == true ? "heart.fill" : "heart")
                                            .foregroundColor(viewModel.likedExperiences[experience.id] == true ? Color(hex: "#F18757") : .gray)
                                            .onTapGesture {
                                                // Call the like function to toggle like state
                                                viewModel.likeExperience(experience: experience)
                                            }

                }
            }
            .padding(.horizontal)
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



