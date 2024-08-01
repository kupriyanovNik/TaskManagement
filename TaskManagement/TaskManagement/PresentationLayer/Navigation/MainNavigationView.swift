//
//  MainNavigationView.swift
//

import SwiftUI

struct MainNavigationView: View {

    // MARK: - Property Wrappers

    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var tabBarViewModel: TabBarViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var allTasksViewModel: AllTasksViewModel
    @ObservedObject var habitsViewModel: HabitsViewModel
    @ObservedObject var taskAddingViewModel: TaskAddingViewModel
    @ObservedObject var habitAddingViewModel: HabitAddingViewModel
    @ObservedObject var sleeptimeCalculatorViewModel: SleeptimeCalculatorViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var informationViewModel: InformationViewModel
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var infiniteCalendarVM: InfiniteCalendarViewModel

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                Color.white

                VStack {
                    switch navigationManager.selectedTab {
                    case .home:
                        HomeView(
                            homeViewModel: homeViewModel,
                            settingsViewModel: settingsViewModel,
                            navigationManager: navigationManager,
                            coreDataManager: coreDataManager,
                            themeManager: themeManager,
                            infiniteCalendarVM: infiniteCalendarVM
                        )

                    case .habits:
                        HabitsView(
                            habitsViewModel: habitsViewModel,
                            settingsViewModel: settingsViewModel,
                            navigationManager: navigationManager,
                            coreDataManager: coreDataManager,
                            themeManager: themeManager
                        )

                    case .profile:
                        ProfileView(
                            profileViewModel: profileViewModel,
                            sleeptimeCalculatorViewModel: sleeptimeCalculatorViewModel,
                            settingsViewModel: settingsViewModel,
                            informationViewModel: informationViewModel,
                            coreDataManager: coreDataManager,
                            networkManager: networkManager,
                            themeManager: themeManager
                        )
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                CustomTabBar(
                    tabBarViewModel: tabBarViewModel,
                    navigationManager: navigationManager,
                    homeViewModel: homeViewModel,
                    allTasksViewModel: allTasksViewModel,
                    habitsViewModel: habitsViewModel,
                    settingsViewModel: settingsViewModel,
                    coreDataManager: coreDataManager,
                    taskAddingViewModel: taskAddingViewModel,
                    habitAddingViewModel: habitAddingViewModel,
                    themeManager: themeManager,
                    infiniteCalendarViewModel: infiniteCalendarVM
                )
                .padding(.bottom, 5)
            }
            .ignoresSafeArea(.keyboard)
            .animation(
                .linear(duration: settingsViewModel.shouldShowTabBarAnimation ? 0.3 : 0.0),
                value: navigationManager.selectedTab
            )
            .onAppear {
                UITabBar.appearance().isHidden = true
            }
        }
    }
}
