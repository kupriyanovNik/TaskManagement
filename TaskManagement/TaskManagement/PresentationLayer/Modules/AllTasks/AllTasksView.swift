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

    // MARK: - Private Properties

    private var systemImages = ImageNames.System.self
    private var strings = Localizable.AllTasks.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
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
        .makeCustomNavBar {
            headerView()
        }
        .onChange(of: allTasksViewModel.filteringCategory) { _ in
            coreDataViewModel.fetchTasksFilteredByCategory(
                taskCategory: allTasksViewModel.filteringCategory
            )
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
                )
            }
        }
    }

    @ViewBuilder func headerView() -> some View {
        let tasksCount = coreDataViewModel.allTasks.filter { !$0.isCompleted }.count

        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Group {
                    if allTasksViewModel.showGreetings {
                        Text("\(tasksCount) \(tasksCount == 1 ? strings.taskLowercased : strings.tasksLowercased)")
                            .transition(.move(edge: .trailing).combined(with: .opacity).combined(with: .scale))
                    } else {
                        Text(strings.your)
                            .transition(.move(edge: .leading).combined(with: .opacity).combined(with: .scale))
                    }
                }
                .foregroundColor(.gray)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.default) {
                            self.allTasksViewModel.showGreetings = false
                        }
                    }
                }

                Text(strings.tasks)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(themeManager.selectedTheme.pageTitleColor)
                    .scaleEffect(allTasksViewModel.showHeaderTap ? 1.1 : 1)
            }
            .hLeading()
            .onLongPressGesture(minimumDuration: 0.7, maximumDistance: 50) {
                withAnimation {
                    allTasksViewModel.showFilteringView = true
                }
            } onPressingChanged: { isPressed in
                withAnimation {
                    allTasksViewModel.showHeaderTap = isPressed
                }
            }


            if !coreDataViewModel.allTasks.isEmpty && allTasksViewModel.filteringCategory == nil {
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
            } else if let category = allTasksViewModel.filteringCategory {
                Text(category.localizableRawValue)
                    .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }
}

#Preview {
    AllTasksView()
        .environmentObject(CoreDataViewModel())
        .environmentObject(HomeViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(NavigationViewModel())
        .environmentObject(AllTasksViewModel())
        .environmentObject(ThemeManager())
}
