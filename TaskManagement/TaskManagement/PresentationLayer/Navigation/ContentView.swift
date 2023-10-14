//
//  ContentView.swift
//

import SwiftUI

struct ContentView: View {

    // MARK: - Property Wrappers
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var tabBarViewModel: TabBarViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var allTasksViewModel: AllTasksViewModel
    @EnvironmentObject var addingViewModel: AddingViewModel
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
                            .environmentObject(themeManager)
                    case .allTasks:
                        AllTasksView()
                            .environmentObject(allTasksViewModel)
                            .environmentObject(homeViewModel)
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
                    .environmentObject(coreDataViewModel)
                    .environmentObject(addingViewModel)
                    .environmentObject(themeManager)
                    .padding(.top)
                    .padding(.bottom, 5)
            }
            .ignoresSafeArea(.keyboard)
            .animation(.linear(duration: 0.3), value: navigationViewModel.selectedTab)
        }
    }
}
