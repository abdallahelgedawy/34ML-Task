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

    var body: some View {
        NavigationView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Welcome Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome!")
                            .font(.custom("GothamRounded-Bold", size: 22))
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
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ExperienceCard(imageName: "nubianHouse", title: "Nubian House", views: 156, likes: 372, isRecommended: true) .frame(width: UIScreen.main.bounds.width * 0.9)
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
                        
                        VStack(spacing: 15) {
                            ExperienceCard(imageName: "egyptianDesert", title: "Egyptian Desert", views: 156, likes: 45, isRecommended: false)
                        }
                        .padding(.all)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Action for menu
                        print("Menu tapped")
                    }) {
                        Image("Menu")
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("Search")
                        TextField("Try \"Luxor\"", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .submitLabel(.search)
                            .onSubmit {
                                //
                            }
                    }
                    .padding(.horizontal)
                    .frame(height: 36)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for settings
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

struct ExperienceCard: View {
    let imageName: String
    let title: String
    let views: Int
    let likes: Int
    let isRecommended: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .overlay(
                        VStack(alignment: .leading) {
                            if isRecommended {
                                Text("RECOMMENDED")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(5)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                                    .padding([.top, .leading])
                            }
                            Spacer()
                        }
                    )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.custom("Gotham-Bold", size: 14))
                    HStack {
                        Text("\(views) views")
                            .font(.custom("GothamMedium", size: 14))
                            .foregroundColor(.white)
                        Spacer()
                        HStack {
                            Text("\(likes)") // Display likes count
                                .font(.custom("GothamMedium", size: 14))
                                .foregroundColor(.black)

                            Image(systemName: "heart.fill") // SF Symbol for heart
                                .foregroundColor(Color(hex: "#F18757")) // Custom color
                                .font(.system(size: 16)) // Adjust size as needed
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

