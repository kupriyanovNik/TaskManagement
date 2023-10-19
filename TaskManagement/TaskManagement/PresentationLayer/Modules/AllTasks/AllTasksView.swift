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
            }
            .padding()
            .padding(.top)
        }
        .makeCustomNavBar {
            headerView()
        }
    }

    // MARK: - ViewBuilders

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
            }
            .hLeading()

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
