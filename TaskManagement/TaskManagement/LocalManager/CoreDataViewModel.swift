//
//  CoreDataViewModel.swift
//

import Foundation
import CoreData
import SwiftUI

class CoreDataViewModel: ObservableObject {

    private var viewContext: NSManagedObjectContext
    private var coreDataNames = Constants.CoreDataNames.self

    init() {
        self.viewContext = PersistenceController.shared.viewContext
        self.fetchFilteredTasks(dateToFilter: .now)
        self.fetchAllTasks()
    }

    @Published var allTasks: [TaskModel] = []
    @Published var filteredTasks: [TaskModel] = []

    func fetchAllTasks() {
        let request = NSFetchRequest<TaskModel>(entityName: coreDataNames.taskModel)
        request.sortDescriptors = [.init(keyPath: \TaskModel.taskDate, ascending: true)]
        do {
            self.allTasks = try viewContext.fetch(request)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }

    func addTask(title: String, description: String?, date: Date, onAdded: ((Date) -> ())?) {
        let task = TaskModel(context: viewContext)
        task.taskTitle = title
        task.taskDescription = description
        task.taskDate = date
        task.isCompleted = false 
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
        self.fetchFilteredTasks(dateToFilter: date)
        onAdded?(date)
    }

    func removeTask(task: TaskModel, date: Date, onRemove: ((Date) -> ())? = nil) {
        viewContext.delete(task)
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
        self.fetchFilteredTasks(dateToFilter: date)
        onRemove?(date)
    }

    func updateTask(task: TaskModel, title: String, description: String?) {
        task.taskTitle = title
        task.taskDescription = description
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }

    func doneTask(task: TaskModel, date: Date) {
        task.isCompleted = true
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
        self.fetchFilteredTasks(dateToFilter: date)
    }

    func undoneTask(task: TaskModel, date: Date) {
        task.isCompleted = false
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
        self.fetchFilteredTasks(dateToFilter: date)
    }

    func fetchFilteredTasks(dateToFilter: Date) {
        let today = Calendar.current.startOfDay(for: dateToFilter)
        let tommorow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        let filterKey = "taskDate"
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today, tommorow])

        let request = NSFetchRequest<TaskModel>(entityName: coreDataNames.taskModel)
        request.sortDescriptors = [.init(keyPath: \TaskModel.taskDate, ascending: true)]
        request.predicate = predicate

        do {
            self.filteredTasks = try viewContext.fetch(request)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
        self.fetchAllTasks()
    }

}
