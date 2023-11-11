//
//  AllTasksView.swift
//

import SwiftUI

struct AllTasksView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var allTasksViewModel: AllTasksViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties

    private var systemImages = ImageNames.System.self
    private var strings = Localizable.AllTasks.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            // MARK: I encountered bugs with redrawing due to the Lazy

            VStack(spacing: 20) {
                if coreDataViewModel.allTasks.isEmpty {
                    Text(strings.noTasks)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .offset(y: 100)

                } else {
                    if allTasksViewModel.filteringCategory == nil {
                        allTasks()
                    } else {
                        tasksFilteredByCategory()
                    }
                }
            }
            .padding()
            .padding(.top)
            .blur(radius: allTasksViewModel.showFilteringView ? 3 : 0)
        }
        .animation(.default, value: coreDataViewModel.allTasks)
        .animation(.default, value: coreDataViewModel.tasksFilteredByCategory)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
            headerView()
        }
        .onChange(of: allTasksViewModel.filteringCategory) { _ in
            fetchTasksFilteredByCategory()
            allTasksViewModel.isEditing = false
        }
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
                                        radius: 30 + (allTasksViewModel.verticalOffset / 7)
                                    )
                                )
                                .ignoresSafeArea()

                            FilterSelectorView(
                                selectedCategory: $allTasksViewModel.filteringCategory,
                                title: strings.selectCategory,
                                accentColor: themeManager.selectedTheme.accentColor
                            )
                            .opacity(1.0 - (abs(allTasksViewModel.verticalOffset) / 150.0))
                        }
                        .frame(maxHeight: 200)

                        Spacer()
                    }
                    .offset(y: allTasksViewModel.verticalOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation {
                                    allTasksViewModel.verticalOffset = min(0, value.translation.height)
                                }
                            }
                            .onEnded { value in
                                if value.translation.height < -100 {
                                    withAnimation {
                                        allTasksViewModel.showFilteringView = false
                                            allTasksViewModel.verticalOffset = 0
                                    }
                                } else {
                                    withAnimation(.spring) {
                                        allTasksViewModel.verticalOffset = 0
                                    }
                                }
                            }
                    )
                }
            }
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func allTasks() -> some View {
        ForEach($coreDataViewModel.allTasks, id: \.id) { $task in
            TaskCardView(
                homeViewModel: homeViewModel,
                navigationViewModel: navigationViewModel,
                coreDataViewModel: coreDataViewModel,
                settingsViewModel: settingsViewModel,
                themeManager: themeManager,
                isEditing: $allTasksViewModel.isEditing,
                task: $task
            )
        }
    }

    @ViewBuilder func tasksFilteredByCategory() -> some View {
        if coreDataViewModel.tasksFilteredByCategory.isEmpty {
            Text(strings.noTasks)
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .offset(y: 100)
        } else {
            ForEach($coreDataViewModel.tasksFilteredByCategory, id: \.id) { $task in
                TaskCardView(
                    homeViewModel: homeViewModel,
                    navigationViewModel: navigationViewModel,
                    coreDataViewModel: coreDataViewModel,
                    settingsViewModel: settingsViewModel,
                    themeManager: themeManager,
                    isEditing: $allTasksViewModel.isEditing,
                    task: $task
                ) {
                    fetchTasksFilteredByCategory()
                }
            }
        }
    }

    @ViewBuilder func headerView() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: systemImages.backArrow)
                    .foregroundColor(.black)
                    .font(.title2)
            }

            VStack(alignment: .leading, spacing: 3) {
                if let filteringCategory = allTasksViewModel.filteringCategory {
                    Text(filteringCategory.localizableRawValue)
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(themeManager.selectedTheme.pageTitleColor)
                        .scaleEffect(allTasksViewModel.showHeaderTap ? 1.1 : 1)
                } else {
                    Text(strings.tasks)
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(themeManager.selectedTheme.pageTitleColor)
                        .scaleEffect(allTasksViewModel.showHeaderTap ? 1.1 : 1)
                }
            }
            .hLeading()
            .onLongPressGesture(minimumDuration: 0.7, maximumDistance: 50) {
                withAnimation {
                    generateFeedback()
                    allTasksViewModel.showFilteringView = true
                }
            } onPressingChanged: { isPressed in
                withAnimation {
                    allTasksViewModel.showHeaderTap = isPressed
                }
            }


            if !coreDataViewModel.allTasks.isEmpty {
                Group {
                    if allTasksViewModel.isEditing {
                        Button(strings.done) {
                            withAnimation {
                                allTasksViewModel.isEditing.toggle()
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .scale))

                    } else {
                        Button(strings.edit) {
                            withAnimation {
                                allTasksViewModel.isEditing.toggle()
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
                    }
                }
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }

    // MARK: - Private Functions

    private func fetchTasksFilteredByCategory() {
        if let filteringCategory = allTasksViewModel.filteringCategory {
            coreDataViewModel.fetchTasksFilteredByCategory(taskCategory: filteringCategory)
        }
    }

}

// MARK: - Preview

#Preview {
    AllTasksView()
        .environmentObject(CoreDataViewModel())
        .environmentObject(HomeViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(NavigationViewModel())
        .environmentObject(AllTasksViewModel())
        .environmentObject(ThemeManager())
}
