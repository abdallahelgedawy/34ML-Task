//
//  CoreDataTests.swift
//  Around EgyptTests
//
//  Created by Abdallah Elgedawy on 06/12/2024.
//

import Foundation
import XCTest
import CoreData
@testable import Around_Egypt

final class CoreDataTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        // Create the in-memory persistent container
        persistentContainer = CoreDataTestHelper.createInMemoryPersistentContainer()
        context = persistentContainer.viewContext
    }

    override func tearDownWithError() throws {
        // Reset the context after each test
        context.rollback()
    }
    
    func testSaveExperience() throws {
        // Create mock data (an Experience object in Core Data)
        let experienceEntity = NSEntityDescription.entity(forEntityName: "ExpEntity", in: context)!
        let experience = NSManagedObject(entity: experienceEntity, insertInto: context)
        
        // Set mock data values (replace with the actual attributes of your entity)
        experience.setValue("Experience 1", forKey: "title")
        experience.setValue("url1", forKey: "cover")
        experience.setValue(100, forKey: "views")
        experience.setValue(10, forKey: "likes")
        experience.setValue("recent", forKey: "type")
        experience.setValue(1, forKey: "recommended")
        
        // Save to Core Data
        do {
            try context.save()
        } catch {
            XCTFail("Failed to save mock data: \(error.localizedDescription)")
        }

        // Fetch saved data to verify
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ExpEntity")
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 1, "There should be one saved experience.")
            XCTAssertEqual(results.first?.value(forKey: "title") as? String, "Experience 1", "The title should be 'Experience 1'.")

        } catch {
            XCTFail("Failed to fetch data: \(error.localizedDescription)")
        }
    }

    func testFetchExperiences() throws {
        // Insert mock data into Core Data
        let experienceEntity = NSEntityDescription.entity(forEntityName: "ExpEntity", in: context)!
        let experience1 = NSManagedObject(entity: experienceEntity, insertInto: context)
        experience1.setValue("Experience 1", forKey: "title")
        experience1.setValue("url1", forKey: "cover")
        experience1.setValue(100, forKey: "views")
        experience1.setValue(10, forKey: "likes")
        experience1.setValue("recent", forKey: "type")
        experience1.setValue(1, forKey: "recommended")

        
        let experience2 = NSManagedObject(entity: experienceEntity, insertInto: context)
        experience2.setValue("Experience 2", forKey: "title")
        experience2.setValue("url2", forKey: "cover")
        experience2.setValue(200, forKey: "views")
        experience2.setValue(20, forKey: "likes")
        experience2.setValue("recommended", forKey: "type")
        experience2.setValue(2, forKey: "recommended")
        // Save the mock data to Core Data
        do {
            try context.save()
        } catch {
            XCTFail("Failed to save mock data: \(error.localizedDescription)")
        }

        // Fetch all experiences
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "ExpEntity")
        do {
            let results = try context.fetch(fetchRequest)
            XCTAssertEqual(results.count, 2, "There should be two experiences.")
            XCTAssertEqual(results.first?.value(forKey: "title") as? String, "Experience 1", "The first experience should be 'Experience 1'.")
            XCTAssertEqual(results.last?.value(forKey: "title") as? String, "Experience 2", "The second experience should be 'Experience 2'.")
        } catch {
            XCTFail("Failed to fetch data: \(error.localizedDescription)")
        }
    }
    
}
