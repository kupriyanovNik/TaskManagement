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
        return Button {
            navigationViewModel.selectedTab = .home
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
        .animation(.linear, value: navigationViewModel.selectedTab)
    }
    private var profileButton: some View {
        return Button {
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
        .animation(.linear, value: navigationViewModel.selectedTab)
    }
    private var plusButton: some View {
        return Button {
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

    // MARK: Body
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 24) {
                plusButton
                    .padding(.horizontal, 24)
                    .frame(height: 72)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
                    )
                HStack(spacing: 0) {
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
            }
            .onChange(of: navigationViewModel.selectedTab) { _ in
                withAnimation {
                    homeViewModel.isEditing = false
                }
                feedback(style: .rigid)
            }
            .padding(.horizontal, 50)
        }
        .sheet(isPresented: $navigationViewModel.showAddingView) {
            withAnimation {
                homeViewModel.isEditing = false
            }
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
