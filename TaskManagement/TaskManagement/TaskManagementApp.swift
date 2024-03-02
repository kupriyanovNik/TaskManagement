//
//  TaskManagementApp.swift
//

import SwiftUI

@main
struct TaskManagementApp: App {

    // MARK: - Property Wrappers

    @AppStorage(
        UserDefaultsKeys.shouldShowOnboarding.rawValue
    ) var shouldShowOnboarding: Bool = true

    @StateObject private var navigationViewModel = NavigationViewModel()
    @StateObject private var tabBarViewModel = TabBarViewModel()
    @StateObject private var coreDataManager = CoreDataManager()
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
                
                MainNavigationView(
                    navigationViewModel: navigationViewModel,
                    tabBarViewModel: tabBarViewModel,
                    coreDataManager: coreDataManager,
                    homeViewModel: homeViewModel,
                    allTasksViewModel: allTasksViewModel,
                    habitsViewModel: habitsViewModel,
                    taskAddingViewModel: taskAddingViewModel,
                    habitAddingViewModel: habitAddingViewModel,
                    sleeptimeCalculatorViewModel: sleeptimeCalculatorViewModel,
                    profileViewModel: profileViewModel,
                    settingsViewModel: settingsViewModel,
                    informationViewModel: informationViewModel,
                    newsViewModel: newsViewModel,
                    networkManager: networkManager,
                    themeManager: themeManager
                )
                .ignoresSafeArea()
                .overlay {
                    VStack {
                        if shouldShowOnboarding {
                            OnboardingView(
                                settingsViewModel: settingsViewModel,
                                shouldShowOnboarding: $shouldShowOnboarding
                            )
                            .transition(.opacity.combined(with: .scale).animation(.spring))
                        }
                    }
                }
            }
            .preferredColorScheme(.light)
        }
    }
}
