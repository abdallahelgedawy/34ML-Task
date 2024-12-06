//
//  CoreDataTestHelper.swift
//  Around EgyptTests
//
//  Created by Abdallah Elgedawy on 06/12/2024.
//

import Foundation
import CoreData
import XCTest
@testable import Around_Egypt

class CoreDataTestHelper {
    static func createInMemoryPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "ExpEntity")  // Use your Core Data model name here
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType  // Use in-memory store for testing
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load store: \(error.localizedDescription)")
            }
        }
        return container
    }
}
