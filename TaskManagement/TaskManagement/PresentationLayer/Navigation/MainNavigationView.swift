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
    @EnvironmentObject var sleeptimeCalculatorViewModel: SleeptimeCalculatorViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var networkManager: NetworkManager
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
                            .environmentObject(sleeptimeCalculatorViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(coreDataViewModel)
                            .environmentObject(networkManager)
                            .environmentObject(themeManager)
                        
                    case .habits:
                        HabitsView()
                            .environmentObject(habitsViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(navigationViewModel)
                            .environmentObject(coreDataViewModel)
                            .environmentObject(themeManager)
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
                    .environmentObject(habitsViewModel)
                    .environmentObject(coreDataViewModel)
                    .environmentObject(taskAddingViewModel)
                    .environmentObject(habitAddingViewModel)
                    .environmentObject(themeManager)
                    .padding(.bottom, 5)
            }
            .ignoresSafeArea(.keyboard)
            .animation(
                .linear(duration: settingsViewModel.shouldShowTabBarAnimation ? 0.3 : 0.0),
                value: navigationViewModel.selectedTab
            )
        }
    }
}
