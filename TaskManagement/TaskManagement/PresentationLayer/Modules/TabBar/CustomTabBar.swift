//
//  CustomTabBar.swift
//

import SwiftUI

struct CustomTabBar: View {

    // MARK: - Property Wrappers

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var tabBarViewModel: TabBarViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var allTasksViewModel: AllTasksViewModel
    @ObservedObject var habitsViewModel: HabitsViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var taskAddingViewModel: TaskAddingViewModel
    @ObservedObject var habitAddingViewModel: HabitAddingViewModel
    @ObservedObject var themeManager: ThemeManager
    @ObservedObject var infiniteCalendarViewModel: InfiniteCalendarViewModel

    // MARK: Private Properties

    private let systemImages = ImageConstants.System.self
    private let tabBarImages = ImageConstants.TabBarImages.self

    private var homeButton: some View {
        let isSelected = navigationManager.selectedTab == .home

        return Button {
            if navigationManager.selectedTab == .home {
                if !coreDataManager.allTasks.isEmpty {
                    navigationManager.showAllTasksView.toggle()
                }
            } else {
                navigationManager.selectedTab = .home
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
        let isSelected = navigationManager.selectedTab == .profile

        return Button {
            navigationManager.selectedTab = .profile
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
        let isSelected = navigationManager.selectedTab == .habits

        return Button {
            navigationManager.selectedTab = .habits
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
            navigationManager.showTaskAddingView.toggle()
        } longAction: {
            navigationManager.showHabitAddingView.toggle()
        }
    }

    private var taskAddingView: some View {
        TaskAddingView(
            homeViewModel: homeViewModel,
            navigationManager: navigationManager,
            coreDataManager: coreDataManager,
            taskAddingViewModel: taskAddingViewModel,
            themeManager: themeManager,
            infiniteCalendarVM: infiniteCalendarViewModel
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
            NavigationLink(isActive: $navigationManager.showAllTasksView) {
                AllTasksView(
                    allTasksViewModel: allTasksViewModel,
                    homeViewModel: homeViewModel,
                    settingsViewModel: settingsViewModel,
                    navigationManager: navigationManager,
                    coreDataManager: coreDataManager,
                    themeManager: themeManager,
                    infiniteCalendarVM: infiniteCalendarViewModel
                )
            } label: {}
        }
        .onChange(of: navigationManager.selectedTab) { _ in
            dismissEditInAllScreens()
            
            ImpactManager.generateFeedback(style: .rigid)
        }
        .padding(.horizontal, 30)
        .animation(.linear, value: coreDataManager.allTasks.isEmpty)
        .sheet(isPresented: $navigationManager.showTaskAddingView) {
            taskAddingViewDismissAction()
        } content: {
            taskAddingView
        }
        .sheet(isPresented: $navigationManager.showHabitAddingView) {
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
        coreDataManager.fetchTasksFilteredByDate(dateToFilter: infiniteCalendarViewModel.selectedDate)

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
