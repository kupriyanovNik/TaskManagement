//
//  CoreDataViewModel.swift
//

import Foundation
import CoreData
import SwiftUI

class CoreDataViewModel: ObservableObject {

    @Published var allTasks: [TaskModel] = []
    @Published var filteredTasks: [TaskModel] = []

    private var viewContext: NSManagedObjectContext
    private var coreDataNames = Constants.CoreDataNames.self

    init() {
        self.viewContext = PersistenceController.shared.viewContext
        self.fetchFilteredTasks(dateToFilter: .now)
        self.fetchAllTasks()
    }

    func fetchAllTasks() {
        let request = NSFetchRequest<TaskModel>(entityName: coreDataNames.taskModel)
        request.sortDescriptors = [.init(keyPath: \TaskModel.taskDate, ascending: true)]
        do {
            self.allTasks = try viewContext.fetch(request)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }

    func addTask(
        id: String,
        title: String,
        description: String?,
        date: Date,
        category: TaskCategory,
        shouldNotificate: Bool,
        onAdded: ((Date, TaskModel) -> ())?
    ) {
        let task = TaskModel(context: viewContext)
        task.taskID = id
        task.taskTitle = title
        task.taskDescription = description
        task.taskDate = date
        task.taskCategory = category.localizableRawValue
        task.shouldNotificate = shouldNotificate
        task.isCompleted = false
        saveContext()
        self.fetchFilteredTasks(dateToFilter: date)
        onAdded?(date, task)
    }

    func removeTask(task: TaskModel, date: Date, onRemove: ((Date) -> ())? = nil) {
        viewContext.delete(task)
        saveContext()
        self.fetchFilteredTasks(dateToFilter: date)
        onRemove?(date)
    }

    func updateTask(task: TaskModel, title: String, description: String?) {
        task.taskTitle = title
        task.taskDescription = description
        saveContext()
    }

    func doneTask(task: TaskModel, date: Date) {
        task.isCompleted = true
        saveContext()
        self.fetchFilteredTasks(dateToFilter: date)
    }

    func undoneTask(task: TaskModel, date: Date) {
        task.isCompleted = false
        saveContext()
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

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }

}
