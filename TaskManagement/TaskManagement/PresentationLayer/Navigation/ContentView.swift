//
//  ContentView.swift
//

import SwiftUI

struct ContentView: View {

    // MARK: - Property Wrappers
    @StateObject private var navigationViewModel = NavigationViewModel()
    @StateObject private var tabBarViewModel = TabBarViewModel()
    @StateObject private var coreDataViewModel = CoreDataViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var allTasksViewModel = AllTasksViewModel()
    @StateObject private var addingViewModel = AddingViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var themeManager = ThemeManager()

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
                            .environmentObject(coreDataViewModel)
                            .environmentObject(themeManager)
                    case .profile:
                        ProfileView()
                            .environmentObject(settingsViewModel)
                            .environmentObject(themeManager)
                    case .allTasks:
                        AllTasksView()
                            .environmentObject(allTasksViewModel)
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
                    .environmentObject(coreDataViewModel)
                    .environmentObject(addingViewModel)
                    .environmentObject(themeManager)
                    .padding(.top)
            }
            .ignoresSafeArea(.keyboard)
            .animation(.linear(duration: 0.3), value: navigationViewModel.selectedTab)
        }
    }
}

#Preview {
    ContentView()
}
