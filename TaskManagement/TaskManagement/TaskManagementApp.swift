//
//  TaskManagementApp.swift
//

import SwiftUI

@main
struct TaskManagementApp: App {

    // MARK: - Property Wrappers

    @AppStorage(
        Constants.UserDefaultsKeys.shouldShowOnboarding
    ) var shouldShowOnboarding: Bool = true

    @StateObject private var navigationViewModel = NavigationViewModel()
    @StateObject private var tabBarViewModel = TabBarViewModel()
    @StateObject private var coreDataViewModel = CoreDataViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var allTasksViewModel = AllTasksViewModel()
    @StateObject private var habitsViewModel = HabitsViewModel()
    @StateObject private var taskAddingViewModel = TaskAddingViewModel()
    @StateObject private var habitAddingViewModel = HabitAddingViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var sleeptimeCalculatorViewModel = SleeptimeCalculatorViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var informationViewModel = InformationViewModel()
    @StateObject private var newsViewModel = NewsViewModel()
    @StateObject private var networkManager = NetworkManager()
    @StateObject private var themeManager = ThemeManager()

    // MARK: - Inits

    init() {
        NotificationManager.shared.checkNotificationStatus()
    }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                MainNavigationView()
                    .environmentObject(navigationViewModel)
                    .environmentObject(tabBarViewModel)
                    .environmentObject(coreDataViewModel)
                    .environmentObject(homeViewModel)
                    .environmentObject(allTasksViewModel)
                    .environmentObject(habitsViewModel)
                    .environmentObject(taskAddingViewModel)
                    .environmentObject(habitAddingViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(sleeptimeCalculatorViewModel)
                    .environmentObject(settingsViewModel)
                    .environmentObject(informationViewModel)
                    .environmentObject(newsViewModel)
                    .environmentObject(networkManager)
                    .environmentObject(themeManager)
                    .opacity(shouldShowOnboarding ? 0.5 : 1)
                    .ignoresSafeArea()
                    .overlay {
                        if shouldShowOnboarding {
                            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
                                .environmentObject(settingsViewModel)
                        }
                    }
                    .animation(.spring, value: shouldShowOnboarding)
            }
            .preferredColorScheme(.light)
        }
    }
}
