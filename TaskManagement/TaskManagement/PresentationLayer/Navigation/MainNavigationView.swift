//
//  MainNavigationView.swift
//

import SwiftUI

struct MainNavigationView: View {

    // MARK: - Property Wrappers

    @ObservedObject var navigationViewModel: NavigationViewModel
    @ObservedObject var tabBarViewModel: TabBarViewModel
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var allTasksViewModel: AllTasksViewModel
    @ObservedObject var habitsViewModel: HabitsViewModel
    @ObservedObject var taskAddingViewModel: TaskAddingViewModel
    @ObservedObject var habitAddingViewModel: HabitAddingViewModel
    @ObservedObject var sleeptimeCalculatorViewModel: SleeptimeCalculatorViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var informationViewModel: InformationViewModel
    @ObservedObject var newsViewModel: NewsViewModel
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var themeManager: ThemeManager

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
                        
                    case .habits:
                        HabitsView()
                            .environmentObject(habitsViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(navigationViewModel)
                            .environmentObject(coreDataViewModel)
                            .environmentObject(themeManager)

                    case .profile:
                        ProfileView()
                            .environmentObject(profileViewModel)
                            .environmentObject(sleeptimeCalculatorViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(informationViewModel)
                            .environmentObject(newsViewModel)
                            .environmentObject(coreDataViewModel)
                            .environmentObject(networkManager)
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
            .onAppear {
                UITabBar.appearance().isHidden = true
            }
        }
    }
}
