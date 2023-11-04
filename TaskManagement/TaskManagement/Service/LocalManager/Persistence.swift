//
//  Persistence.swift
//

import CoreData

struct PersistenceController {

    // MARK: - Static Properties

    static let shared = PersistenceController()

    // MARK: - Inits

    init() {
        container = NSPersistentContainer(name: Constants.CoreDataNames.taskManagement)

        container.loadPersistentStores { description, error in
            if let error  {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }

        viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Internal Properties

    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
}
