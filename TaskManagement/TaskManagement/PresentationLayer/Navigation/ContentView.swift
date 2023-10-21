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
                            .environmentObject(coreDataViewModel)
                            .environmentObject(themeManager)
                        
                    case .allTasks:
                        AllTasksView()
                            .environmentObject(allTasksViewModel)
                            .environmentObject(homeViewModel)
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
                    .environmentObject(coreDataViewModel)
                    .environmentObject(addingViewModel)
                    .environmentObject(themeManager)
                    .padding(.top)
                    .padding(.bottom, 5)
            }
            .ignoresSafeArea(.keyboard)
            .animation(
                settingsViewModel.shouldShowTabBarAnimation ? .linear(duration: 0.3) : .linear(duration: 0),
                value: navigationViewModel.selectedTab
            )
            .overlay {
                if allTasksViewModel.showFilteringView {
                    ZStack {
                        Color.black
                            .opacity(0.8)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    allTasksViewModel.showFilteringView = false
                                }
                            }

                        VStack {
                            ZStack {
                                Color.white
                                    .clipShape(
                                        RoundedShape(
                                            corners: [.bottomLeft, .bottomRight],
                                            radius: 30
                                        )
                                    )
                                    .ignoresSafeArea()

                                FilterSelectorView(
                                    selectedCategory: $allTasksViewModel.filteringCategory,
                                    title: "Выберите категорию",
                                    accentColor: themeManager.selectedTheme.accentColor
                                )
                            }
                            .frame(maxHeight: 150)

                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
