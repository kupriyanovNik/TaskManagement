//
//  CoreDataManager.swift
//

import Foundation
import CoreData
import SwiftUI

final class CoreDataManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published var allTasks: [TaskModel] = []
    @Published var allTodayTasks: [TaskModel] = []
    @Published var tasksFilteredByDate: [TaskModel] = []
    @Published var tasksFilteredByCategory: [TaskModel] = []

    @Published var allHabits: [HabitModel] = []

    // MARK: - Private Properties

    private var viewContext: NSManagedObjectContext
    private var coreDataNames = CoreDataConstants.self

    // MARK: - Inits

    init() {
        self.viewContext = PersistenceController.shared.viewContext
        self.fetchTasksFilteredByDate(dateToFilter: .now)
        self.fetchAllHabits()
    }

    // MARK: - Internal Functions

    func addTask(
        id: String,
        title: String,
        description: String?,
        date: Date,
        category: TaskCategory,
        shouldNotificate: Bool,
        onAdded: ((Date, TaskModel) -> ())? = nil
    ) {
        let task = TaskModel(context: viewContext)
        task.taskID = id
        task.taskTitle = title
        task.taskDescription = description
        task.taskDate = date
        task.taskCategory = Int16(category.rawValue)
        task.shouldNotificate = shouldNotificate
        task.isCompleted = false
        saveContext()
        self.fetchTasksFilteredByDate(dateToFilter: date)
        onAdded?(date, task)
    }

    func removeTask(
        task: TaskModel,
        onRemove: ((Date) -> ())? = nil
    ) {
        viewContext.delete(task)
        saveContext()
        
        let date = task.taskDate ?? .now

        self.fetchTasksFilteredByDate(dateToFilter: date)
        onRemove?(date)
    }

    func updateTask(
        task: TaskModel,
        title: String,
        description: String?,
        shouldNotificate: Bool,
        onUpdate: ((Date) -> ())? = nil
    ) {
        task.taskTitle = title
        task.taskDescription = description
        task.shouldNotificate = shouldNotificate
        saveContext()
        self.fetchTasksFilteredByDate(dateToFilter: task.taskDate ?? .now)
    }

    func doneTask(
        task: TaskModel,
        date: Date
    ) {
        task.isCompleted = true
        task.shouldNotificate = false
        saveContext()
        self.fetchTasksFilteredByDate(dateToFilter: date)
    }

    func undoneTask(
        task: TaskModel,
        date: Date
    ) {
        task.isCompleted = false
        saveContext()
        self.fetchTasksFilteredByDate(dateToFilter: date)
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

    func fetchTasksFilteredByDate(dateToFilter: Date) {
        let today = Calendar.current.startOfDay(for: dateToFilter)
        let tommorow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        let filterKey = "taskDate"
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today, tommorow])

        let request = NSFetchRequest<TaskModel>(entityName: coreDataNames.taskModel)
        request.sortDescriptors = [.init(keyPath: \TaskModel.taskDate, ascending: true)]
        request.predicate = predicate

        do {
            self.tasksFilteredByDate = try viewContext.fetch(request)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
        self.fetchAllTasks()
        self.fetchTodayTasks()
    }

    func fetchTodayTasks() {
        let today = Calendar.current.startOfDay(for: .now)
        let tommorow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        let filterKey = "taskDate"
        let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today, tommorow])

        let request = NSFetchRequest<TaskModel>(entityName: coreDataNames.taskModel)
        request.sortDescriptors = [.init(keyPath: \TaskModel.taskDate, ascending: true)]
        request.predicate = predicate

        do {
            self.allTodayTasks = try viewContext.fetch(request)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func fetchTasksFilteredByCategory(taskCategory: TaskCategory) {
        let filterKey = "taskCategory"
        let predicate = NSPredicate(format: "\(filterKey) = %@", argumentArray: [taskCategory.rawValue])

        let request = NSFetchRequest<TaskModel>(entityName: coreDataNames.taskModel)
        request.sortDescriptors = [.init(keyPath: \TaskModel.taskDate, ascending: true)]
        request.predicate = predicate
        
        do {
            self.tasksFilteredByCategory = try viewContext.fetch(request)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }

    func addHabit(
        id: String,
        title: String,
        description: String,
        color: String,
        shouldNotificate: Bool,
        notificationIDs: [String]?,
        notificationText: String,
        weekDays: [Int],
        onAdded: ((HabitModel) -> ())? = nil
    ) {
        let habit = HabitModel(context: viewContext)
        habit.habitID = id
        habit.title = title
        habit.habitDescription = description
        habit.color = color
        habit.isReminderOn = shouldNotificate
        habit.notificationIDs = notificationIDs
        habit.reminderText = notificationText
        habit.weekDays = weekDays
        habit.dateAdded = .now

        saveContext()
        self.fetchAllHabits()
        onAdded?(habit)
    }

    func removeHabit(
        habit: HabitModel,
        onRemove: ((Date, [String]) -> ())? = nil
    ) {
        viewContext.delete(habit)
        saveContext()

        let date = habit.dateAdded ?? .now

        onRemove?(date, habit.notificationIDs ?? [])
    }

    func updateHabit(
        habit: HabitModel,
        title: String,
        description: String,
        weekDays: [Int],
        color: String,
        shouldNotificate: Bool,
        reminderText: String,
        onUpdate: ((Date) -> ())? = nil
    ) {
        habit.title = title
        habit.habitDescription = description
        habit.weekDays = weekDays
        habit.color = color
        habit.isReminderOn = shouldNotificate
        habit.reminderText = reminderText

        saveContext()
    }

    func fetchAllHabits() {
        let request = NSFetchRequest<HabitModel>(entityName: coreDataNames.habitModel)
        request.sortDescriptors = [.init(keyPath: \HabitModel.dateAdded, ascending: true)]

        do {
            self.allHabits = try viewContext.fetch(request)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }

    // MARK: - Private Functions 

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }

}
