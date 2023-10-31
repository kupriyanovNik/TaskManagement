//
//  ContentView.swift
//

import SwiftUI

struct MainNavigationView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var tabBarViewModel: TabBarViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var allTasksViewModel: AllTasksViewModel
    @EnvironmentObject var habitsViewModel: HabitsViewModel
    @EnvironmentObject var taskAddingViewModel: TaskAddingViewModel
    @EnvironmentObject var habitAddingViewModel: HabitAddingViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Inits

    init() {
        UITabBar.appearance().isHidden = true
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                Color.white

                VStack {
                    switch navigationViewModel.selectedTab {
                    case .home:
                        HomeView()
                            .environmentObject(navigationViewModel)
                            .environmentObject(homeViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(coreDataViewModel)
                            .environmentObject(themeManager)

                    case .profile:
                        ProfileView()
                            .environmentObject(profileViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(coreDataViewModel)
                            .environmentObject(themeManager)
                        
                    case .habits:
                        HabitsView()
                            .environmentObject(habitsViewModel)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                CustomTabBar()
                    .environmentObject(navigationViewModel)
                    .environmentObject(tabBarViewModel)
                    .environmentObject(homeViewModel)
                    .environmentObject(allTasksViewModel)
                    .environmentObject(settingsViewModel)
                    .environmentObject(coreDataViewModel)
                    .environmentObject(taskAddingViewModel)
                    .environmentObject(habitAddingViewModel)
                    .environmentObject(themeManager)
                    .padding(.bottom, 5)
            }
            .ignoresSafeArea(.keyboard)
            .animation(
                settingsViewModel.shouldShowTabBarAnimation ? .linear(duration: 0.3) : .linear(duration: 0),
                value: navigationViewModel.selectedTab
            )
        }
    }
}
