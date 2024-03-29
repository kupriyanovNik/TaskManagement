//
//  Persistence.swift
//

import CoreData

struct PersistenceController {

    // MARK: - Static Properties

    static let shared = PersistenceController()

    // MARK: - Inits

    init() {
        container = NSPersistentContainer(name: CoreDataConstants.taskManagement)

        container.loadPersistentStores { description, error in
            if let error  {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }

        viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Internal Properties

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Private Properties

    private let container: NSPersistentContainer
}
