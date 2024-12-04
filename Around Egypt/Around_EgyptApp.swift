//
//  Around_EgyptApp.swift
//  Around Egypt
//
//  Created by Abdallah Elgedawy on 03/12/2024.
//

import SwiftUI

@main
struct Around_EgyptApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
