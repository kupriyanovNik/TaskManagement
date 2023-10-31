//
//  CustomTabBar.swift
//

import SwiftUI

struct CustomTabBar: View {

    // MARK: - Property Wrappers

    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var tabBarViewModel: TabBarViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var allTasksViewModel: AllTasksViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var taskAddingViewModel: TaskAddingViewModel
    @EnvironmentObject var habitAddingViewModel: HabitAddingViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: Private Properties

    private var systemImages = ImageNames.System.self
    private var tabBarImages = ImageNames.TabBarImages.self

    private var homeButton: some View {
        Button {
            if navigationViewModel.selectedTab == .home {
                if !coreDataViewModel.allTasks.isEmpty {
                    navigationViewModel.showAllTasksView.toggle()
                }
            } else {
                navigationViewModel.selectedTab = .home
            }
        } label: {
            HStack {
                Group {
                    Image(systemName: navigationViewModel.selectedTab == .home ? tabBarImages.Active.home : tabBarImages.Inactive.home)
                        .resizable()
                        .transition(.move(edge: .trailing).combined(with: .opacity).combined(with: .scale))
                }
                .frame(width: 25, height: 25)
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .scaleEffect(navigationViewModel.selectedTab == .home ? 1.15 : 1)
        .opacity(navigationViewModel.selectedTab == .home ? 1 : 0.5)
        .animation(.linear, value: navigationViewModel.selectedTab)
    }

    private var profileButton: some View {
        Button {
            navigationViewModel.selectedTab = .profile
        } label: {
            Image(systemName: navigationViewModel.selectedTab == .profile ? tabBarImages.Active.profile : tabBarImages.Inactive.profile)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .scaleEffect(navigationViewModel.selectedTab == .profile ? 1.15 : 1)
        .opacity(navigationViewModel.selectedTab == .profile ? 1 : 0.5)
        .animation(.linear, value: navigationViewModel.selectedTab)
    }

    private var habitsButton: some View {
        Button {
            navigationViewModel.selectedTab = .habits
        } label: {
            Image(systemName: navigationViewModel.selectedTab == .habits ? tabBarImages.Active.allTasks : tabBarImages.Inactive.allTasks)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .scaleEffect(navigationViewModel.selectedTab == .habits ? 1.15 : 1)
        .opacity(navigationViewModel.selectedTab == .habits ? 1 : 0.5)
        .animation(.linear, value: navigationViewModel.selectedTab)
    }

    private var plusButton: some View {
        Button {
            navigationViewModel.showTaskAddingView.toggle()
        } label: {
            ZStack {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                .pink, .indigo,
                                themeManager.selectedTheme.accentColor,
                                .purple, .mint
                            ],
                            startPoint: tabBarViewModel.gradientStart,
                            endPoint: tabBarViewModel.gradientEnd
                        ), style: .init(lineWidth: tabBarViewModel.gradientLineWidth)
                    )
                    .shadow(color: themeManager.selectedTheme.accentColor.opacity(0.5), radius: 10)
                    .rotationEffect(.degrees(tabBarViewModel.gradientRotation))
                    .frame(width: 48)

                if #available(iOS 16, *) {
                    Image(systemName: systemImages.plus)
                        .scaledToFit()
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                } else {
                    Image(systemName: systemImages.plus)
                        .scaledToFit()
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
        }
        .buttonStyle(CirclePlusButtonStyle())
    }

    private var taskAddingView: some View {
        TaskAddingView()
            .environmentObject(homeViewModel)
            .environmentObject(navigationViewModel)
            .environmentObject(coreDataViewModel)
            .environmentObject(taskAddingViewModel)
            .environmentObject(themeManager)
    }

    private var habitAddingView: some View {
        HabitAddingView()
            .environmentObject(habitAddingViewModel)
    }

    // MARK: Body

    var body: some View {
        HStack(spacing: 0) {
            plusButton
            Spacer()
            Divider()
            Spacer()
            homeButton
            Spacer()
            habitsButton
            Spacer()
            profileButton
        }
        .padding(.horizontal, 24)
        .frame(height: 72)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .white, radius: 100, x: 0, y: 100)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
        .overlay {
            NavigationLink(isActive: $navigationViewModel.showAllTasksView) {
                AllTasksView()
                    .environmentObject(allTasksViewModel)
                    .environmentObject(homeViewModel)
                    .environmentObject(settingsViewModel)
                    .environmentObject(navigationViewModel)
                    .environmentObject(coreDataViewModel)
                    .environmentObject(themeManager)
            } label: {}
        }
        .onChange(of: navigationViewModel.selectedTab) { _ in
            dismissEditInAllScreens()
            generateFeedback(style: .rigid)
        }
        .padding(.horizontal, 30)
        .animation(.linear, value: coreDataViewModel.allTasks.isEmpty)
        .sheet(isPresented: $navigationViewModel.showTaskAddingView) {
            addingViewDismissAction()
        } content: {
            taskAddingView
        }
        .sheet(isPresented: $navigationViewModel.showHabitAddingView) {

        } content: {
            habitAddingView
        }
        .onAppear {
            playPlusButtonAnimation()
            playGradientAnimation()
        }
    }

    // MARK: - Private Functions

    private func playPlusButtonAnimation() {
        withAnimation(.linear(duration: 1.5)) {
            tabBarViewModel.gradientLineWidth = 5
        }
    }

    private func playGradientAnimation() {
        withAnimation (.easeInOut(duration: 2.5).repeatForever()) {
            tabBarViewModel.gradientStart = UnitPoint(x: 1, y: -1)
            tabBarViewModel.gradientEnd = UnitPoint(x: 0, y: 1)
            tabBarViewModel.gradientRotation = 36
        }
    }

    private func addingViewDismissAction() {
        dismissEditInAllScreens()
        homeViewModel.editTask = nil
        coreDataViewModel.fetchAllTasks()
        coreDataViewModel.fetchTasksFilteredByDate(dateToFilter: homeViewModel.currentDay)
        if let filteringCategory = allTasksViewModel.filteringCategory {
            coreDataViewModel.fetchTasksFilteredByCategory(taskCategory: filteringCategory)
        }
        taskAddingViewModel.reset()
    }
    
    private func dismissEditInAllScreens() {
        withAnimation {
            homeViewModel.isEditing = false
            allTasksViewModel.isEditing = false
        }
    }
}
