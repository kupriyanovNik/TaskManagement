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
    @EnvironmentObject var addingViewModel: AddingViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @State private var verticalOffset: CGFloat = .zero

    // MARK: - Private Properties

    private var strings = Localizable.Content.self

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
                                    title: strings.selectCategory,
                                    accentColor: themeManager.selectedTheme.accentColor
                                )
                            }
                            .frame(maxHeight: 200)

                            Spacer()
                        }
                        .offset(y: verticalOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    withAnimation {
                                        verticalOffset = min(0, value.translation.height)
                                    }
                                }
                                .onEnded { value in
                                    if value.translation.height < -100 {
                                        withAnimation {
                                            allTasksViewModel.showFilteringView = false
                                            verticalOffset = 0
                                        }
                                    } else {
                                        withAnimation {
                                            verticalOffset = 0
                                        }
                                    }
                                }
                        )
                    }
                }
            }
        }
    }
}
