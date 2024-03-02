//
//  CustomTabBar.swift
//

import SwiftUI

struct CustomTabBar: View {

    // MARK: - Property Wrappers

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var tabBarViewModel: TabBarViewModel
    @ObservedObject var navigationViewModel: NavigationViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var allTasksViewModel: AllTasksViewModel
    @ObservedObject var habitsViewModel: HabitsViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var taskAddingViewModel: TaskAddingViewModel
    @ObservedObject var habitAddingViewModel: HabitAddingViewModel
    @ObservedObject var themeManager: ThemeManager

    // MARK: Private Properties

    private let systemImages = ImageConstants.System.self
    private let tabBarImages = ImageConstants.TabBarImages.self

    private var homeButton: some View {
        let isSelected = navigationViewModel.selectedTab == .home

        return Button {
            if navigationViewModel.selectedTab == .home {
                if !coreDataManager.allTasks.isEmpty {
                    navigationViewModel.showAllTasksView.toggle()
                }
            } else {
                navigationViewModel.selectedTab = .home
            }
        } label: {
            HStack {
                Image(systemName: isSelected ? tabBarImages.Active.home : tabBarImages.Inactive.home)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }
        }
        .buttonStyle(TabItemButtonStyle(isSelected: isSelected))
        .padding(.horizontal)
    }

    private var profileButton: some View {
        let isSelected = navigationViewModel.selectedTab == .profile

        return Button {
            navigationViewModel.selectedTab = .profile
        } label: {
            Image(systemName: isSelected ? tabBarImages.Active.profile : tabBarImages.Inactive.profile)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
        }
        .buttonStyle(TabItemButtonStyle(isSelected: isSelected))
        .padding(.horizontal)
    }

    private var habitsButton: some View {
        let isSelected = navigationViewModel.selectedTab == .habits

        return Button {
            navigationViewModel.selectedTab = .habits
        } label: {
            Image(systemName: isSelected ? tabBarImages.Active.allTasks : tabBarImages.Inactive.allTasks)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
        }
        .buttonStyle(TabItemButtonStyle(isSelected: isSelected))
        .padding(.horizontal)
    }

    private var plusButton: some View {
        PlusButton(
            tabBarViewModel: tabBarViewModel,
            accentColor: themeManager.selectedTheme.accentColor
        ) {
            navigationViewModel.showTaskAddingView.toggle()
        } longAction: {
            navigationViewModel.showHabitAddingView.toggle()
        }
    }

    private var taskAddingView: some View {
        TaskAddingView(
            homeViewModel: homeViewModel,
            navigationViewModel: navigationViewModel,
            coreDataManager: coreDataManager,
            taskAddingViewModel: taskAddingViewModel,
            themeManager: themeManager
        )
    }

    private var habitAddingView: some View {
        HabitAddingView(
            habitAddingViewModel: habitAddingViewModel,
            habitsViewModel: habitsViewModel,
            coreDataManager: coreDataManager,
            themeManager: themeManager
        )
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
                AllTasksView(
                    allTasksViewModel: allTasksViewModel,
                    homeViewModel: homeViewModel,
                    settingsViewModel: settingsViewModel,
                    navigationViewModel: navigationViewModel,
                    coreDataManager: coreDataManager,
                    themeManager: themeManager
                )
            } label: {}
        }
        .onChange(of: navigationViewModel.selectedTab) { _ in
            dismissEditInAllScreens()
            
            ImpactManager.shared.generateFeedback(style: .rigid)
        }
        .padding(.horizontal, 30)
        .animation(.linear, value: coreDataManager.allTasks.isEmpty)
        .sheet(isPresented: $navigationViewModel.showTaskAddingView) {
            taskAddingViewDismissAction()
        } content: {
            taskAddingView
        }
        .sheet(isPresented: $navigationViewModel.showHabitAddingView) {
            habitAddingViewDismissAction()
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

    private func taskAddingViewDismissAction() {
        dismissEditInAllScreens()

        homeViewModel.editTask = nil
        coreDataManager.fetchAllTasks()
        coreDataManager.fetchTasksFilteredByDate(dateToFilter: homeViewModel.currentDay)

        if let filteringCategory = allTasksViewModel.filteringCategory {
            coreDataManager.fetchTasksFilteredByCategory(taskCategory: filteringCategory)
        }

        taskAddingViewModel.reset()
    }

    private func habitAddingViewDismissAction() {
        dismissEditInAllScreens()
        habitAddingViewModel.reset()
        coreDataManager.fetchAllTasks()
    }

    private func dismissEditInAllScreens() {
        withAnimation {
            habitsViewModel.isEditing = false 
            homeViewModel.isEditing = false
            allTasksViewModel.isEditing = false
        }
    }
}
