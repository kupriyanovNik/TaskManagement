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
    @EnvironmentObject var habitsViewModel: HabitsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var taskAddingViewModel: TaskAddingViewModel
    @EnvironmentObject var habitAddingViewModel: HabitAddingViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: Private Properties

    private var systemImages = ImageNames.System.self
    private var tabBarImages = ImageNames.TabBarImages.self

    private var homeButton: some View {
        let isSelected = navigationViewModel.selectedTab == .home

        return Button {
            if navigationViewModel.selectedTab == .home {
                if !coreDataViewModel.allTasks.isEmpty {
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
            .environmentObject(habitsViewModel)
            .environmentObject(coreDataViewModel)
            .environmentObject(themeManager)
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
            
            ImpactManager.shared.generateFeedback(style: .rigid)
        }
        .padding(.horizontal, 30)
        .animation(.linear, value: coreDataViewModel.allTasks.isEmpty)
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
        coreDataViewModel.fetchAllTasks()
        coreDataViewModel.fetchTasksFilteredByDate(dateToFilter: homeViewModel.currentDay)

        if let filteringCategory = allTasksViewModel.filteringCategory {
            coreDataViewModel.fetchTasksFilteredByCategory(taskCategory: filteringCategory)
        }
        taskAddingViewModel.reset()
    }

    private func habitAddingViewDismissAction() {
        dismissEditInAllScreens()
        habitAddingViewModel.reset()
        coreDataViewModel.fetchAllTasks()
    }

    private func dismissEditInAllScreens() {
        withAnimation {
            habitsViewModel.isEditing = false 
            homeViewModel.isEditing = false
            allTasksViewModel.isEditing = false
        }
    }
}
