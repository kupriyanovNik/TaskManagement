//
//  TaskManagementApp.swift
//

import SwiftUI

@main
struct TaskManagementApp: App {

    // MARK: - Property Wrappers

    @AppStorage(Constants.UserDefaultsKeys.shouldShowOnboarding) var shouldShowOnboarding: Bool = true

    @StateObject private var navigationViewModel = NavigationViewModel()
    @StateObject private var tabBarViewModel = TabBarViewModel()
    @StateObject private var coreDataViewModel = CoreDataViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var allTasksViewModel = AllTasksViewModel()
    @StateObject private var habitsViewModel = HabitsViewModel()
    @StateObject private var taskAddingViewModel = TaskAddingViewModel()
    @StateObject private var habitAddingViewModel = HabitAddingViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var themeManager = ThemeManager()

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
                    .environmentObject(settingsViewModel)
                    .environmentObject(themeManager)
                    .opacity(shouldShowOnboarding ? 0.5 : 1)
                    .clipShape(
                        RoundedShape(
                            corners: [.bottomRight, .bottomLeft], 
                            radius: shouldShowOnboarding ? 30 : 0
                        )
                    )
                    .padding(.bottom, shouldShowOnboarding ? 25 : 0)
                    .ignoresSafeArea()
                    .overlay {
                        if shouldShowOnboarding {
                            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
                                .environmentObject(settingsViewModel)
                                .clipShape(
                                    RoundedShape(
                                        corners: [.bottomRight, .bottomLeft],
                                        radius: 30
                                    )
                                )
                                .padding(.bottom, 15)
                                .ignoresSafeArea(edges: .top)
                        }
                    }
                    .animation(.spring(), value: shouldShowOnboarding)
            }
            .preferredColorScheme(.light)
        }
    }
}
