import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExpEntity") // Replace with your .xcdatamodeld name
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save experience with type
    func saveExperience(experience: Experience, type: String) {
        let context = CoreDataStack.shared.context
        let newExperience = ExpEntity(context: context)

        newExperience.title = experience.title
        newExperience.cover = experience.coverPhoto
        newExperience.recommended = Int32(experience.recommended)
        newExperience.views = Int32(experience.viewsNo)
        newExperience.likes = Int32(experience.likesNo)
        newExperience.type = type

        do {
            try context.save()
        } catch {
            print("Error saving experience: \(error)")
        }
    }

    // Fetch experiences by type
    func fetchExperiences(ofType type: String) -> [ExpEntity] {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<ExpEntity> = ExpEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", type)

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching experiences: \(error)")
            return []
        }
    }

    // Clear old experiences of a specific type
    func clearExperiences(ofType type: String) {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ExpEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", type)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error clearing experiences: \(error)")
        }
    }
    func saveExperienceDetail(experience: ExperienceDetail) {
            let context = CoreDataStack.shared.context
            let newExperience = ExpEntity(context: context)

            newExperience.id = experience.id
            newExperience.title = experience.title
            newExperience.cover = experience.coverPhoto
            newExperience.descriptionText = experience.description
            newExperience.views = Int32(experience.viewsNo)
            newExperience.likes = Int32(experience.likesNo)
            newExperience.recommended = Int32(experience.recommended)

            do {
                try context.save()
            } catch {
                print("Error saving experience detail: \(error)")
            }
        }

        // Fetch ExperienceDetail by ID
        func fetchExperienceDetail(withID id: String) -> ExpEntity? {
            let context = CoreDataStack.shared.context
            let fetchRequest: NSFetchRequest<ExpEntity> = ExpEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)

            do {
                let experiences = try context.fetch(fetchRequest)
                return experiences.first
            } catch {
                print("Error fetching experience detail by ID: \(error)")
                return nil
            }
        }

        // Clear ExperienceDetail by ID (if needed)
        func clearExperienceDetail(withID id: String) {
            let context = CoreDataStack.shared.context
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ExpEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteRequest)
            } catch {
                print("Error clearing experience detail: \(error)")
            }
        }
}
