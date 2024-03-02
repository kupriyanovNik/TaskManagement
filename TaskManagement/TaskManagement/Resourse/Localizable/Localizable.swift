//
//  Localizable.swift
//

import Foundation

enum Localizable {
    enum TaskAdding {
        static let title = "Adding.title".localized
        static let save = "Adding.save".localized
        static let cancel = "Adding.cancel".localized
        static let taskTitle = "Adding.taskTitle".localized
        static let taskDescription = "Adding.taskDescription".localized
        static let taskDate = "Adding.taskDate".localized
        static let shouldRemind = "Adding.shouldNotificate".localized
        static let unfinishedTask = "Adding.unfinishedTask".localized
    }

    enum HabitAdding {
        static let title = "HabitAdding.newHabit".localized
        static let habitTitle = "HabitAdding.habitTitle".localized
        static let habitDescription = "HabitAdding.habitDescription".localized
        static let frequency = "HabitAdding.frequency".localized
        static let reminder = "HabitAdding.reminder".localized
        static let justNotifications = "HabitAdding.justNotification".localized
        static let reminderText = "HabitAdding.reminderText".localized
        static let save = "HabitAdding.save".localized
        static let notificationTitle = "HabitAdding.reminderTitle".localized
    }

    enum Home {
        static let markAsCompleted = "Home.markAsCompleted".localized
        static let markedAsCompleted = "Home.markedAsCompleted".localized
        static let today = "Home.today".localized
        static let edit = "Home.edit".localized
        static let done = "Home.done".localized
        static let noTasks = "Home.noTasks".localized
        static let noTasksDescription = "Home.noTasksDescription".localized
        static let willNotificate = "Home.willNotificate".localized
    }

    enum Habits {
        static let title = "Habits.title".localized
        static let subtitle = "Habits.getBetter".localized
        static let done = "Habits.done".localized
        static let edit = "Habits.edit".localized
        static let noHabits = "Habits.notFound".localized
        static let noHabitsDescription = "Habits.noHabitsDescription".localized
    }

    enum Profile {
        static let your = "Profile.your".localized
        static let profile = "Profile.profile".localized
        static let doneTasks = "Profile.doneTasks".localized
        static let todayDoneTasks = "Profile.todayDoneTasks".localized
        static let sleeptimeCalculator = "Profile.sleeptimeCalculator".localized
        static let newsFeed = "Profile.newsFeed".localized
        static let tomorrow = "Profile.tomorrow".localized
    }

    enum SleeptimeCalculator {
        static let title = "Profile.sleeptimeCalculator".localized
        static let wakeUpTime = "SleeptimeCalculator.wakeUpTime".localized
        static let desiredAmount = "SleeptimeCalculator.desiredAmount".localized
        static let coffeeIntake = "SleeptimeCalculator.coffeeIntake".localized
        static let check = "SleeptimeCalculator.check".localized
        static let alertTitle = "SleeptimeCalculator.alertTitle".localized
    }

    enum News {
        static let newsFeed = "News.newsFeed".localized
        static let refresh = "News.refresh".localized
    }

    enum Onboarding {
        static let application = "Onboarding.application".localized
        static let username = "Onboarding.username".localized
        static let userage = "Onboarding.userage".localized
        static let login = "Onboarding.enter".localized
        static let error = "Onboarding.error".localized
    }

    enum Greetings {
        static let morning = "Greetings.morning".localized
        static let day = "Greetings.day".localized
        static let evening = "Greetings.evening".localized
        static let night = "Greetings.night".localized
    }

    enum Settings {
        static let title = "Settings.title".localized
        static let application = "Settings.application".localized
        static let selectTheme = "Settings.selectTheme".localized
        static let showScrollAnimations = "Settings.showScrollAnimations".localized
        static let showTabBarAnimations = "Settings.showTabBarAnimations".localized
    }

    enum Information {
        static let title = "Информация"
    }

    enum AllTasks {
        static let selectCategory = "AllTasks.selectCategory".localized
        static let taskLowercased = "AllTasks.taskLowercased".localized
        static let tasksLowercased = "AllTasks.tasksLowercased".localized
        static let your = "AllTasks.your".localized
        static let tasks = "AllTasks.tasks".localized
        static let done = "AllTasks.done".localized
        static let edit = "AllTasks.edit".localized
        static let noTasks = "Home.noTasks".localized
        static let markAsCompleted = "Home.markAsCompleted".localized
        static let markedAsCompleted = "Home.markedAsCompleted".localized
    }

    enum HabitCard {
        static let everyday = "HabitCard.everyday".localized
        static let timeAweek = "HabitCard.timesAWeek".localized
    }
}
