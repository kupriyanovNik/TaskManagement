//
//  CustomTabBar.swift
//

import SwiftUI

struct CustomTabBar: View {

    // MARK: - Property Wrappers
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var addingViewModel: AddingViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: Private Properties
    private var systemImages = ImageNames.System.self
    private var tabBarImages = ImageNames.TabBarImages.self

    private var homeButton: some View {
        let taskCount = coreDataViewModel.filteredTasks.filter { !$0.isCompleted }.count
        let shouldShowTaskCount = homeViewModel.showGreetings && taskCount != 0
        return Button {
            navigationViewModel.selectedTab = .home
        } label: {
            HStack {
                Image(systemName: navigationViewModel.selectedTab == .home ? tabBarImages.Active.home : tabBarImages.Inactive.home)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(themeManager.selectedTheme.pageTitleColor)
                if shouldShowTaskCount {
                    VStack(spacing: -3) {
                        Text("\(taskCount)")
                        Text(taskCount == 1 ? "task" : "tasks")
                    }
                    .font(.body)
                    .foregroundColor(themeManager.selectedTheme.accentColor)
                }
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .animation(.linear, value: navigationViewModel.selectedTab)
    }
    private var profileButton: some View {
        Button {
            navigationViewModel.selectedTab = .profile
        } label: {
            Image(systemName: navigationViewModel.selectedTab == .profile ? tabBarImages.Active.profile : tabBarImages.Inactive.profile)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
    private var plusButton: some View {
        ZStack {
            Button {
                navigationViewModel.showAddingView.toggle()
            } label: {
                ZStack {
                    Circle()
                        .stroke(themeManager.selectedTheme.accentColor, lineWidth: 2)
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
            .buttonStyle(.plain)
        }
    }

    // MARK: Body
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                plusButton
                Spacer()
                homeButton
                Spacer()
                profileButton
            }
            .padding(.horizontal, 24)
            .frame(height: 72)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
            )
            .onChange(of: navigationViewModel.selectedTab) { _ in
                feedback(style: .rigid)
            }
            .padding(.horizontal, 50)
        }
        .sheet(isPresented: $navigationViewModel.showAddingView) {
            homeViewModel.editTask = nil
            addingViewModel.taskTitle = ""
            addingViewModel.taskDescription = ""
            addingViewModel.taskDate = .now
            navigationViewModel.selectedTab = .home
        } content: {
            AddingView()
                .environmentObject(homeViewModel)
                .environmentObject(navigationViewModel)
                .environmentObject(coreDataViewModel)
                .environmentObject(addingViewModel)
                .environmentObject(themeManager)
        }
    }
}
