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
            VStack(spacing: 15) {
                tasksView()
            }
        }
        .makeCustomNavBar {
            headerView()
        }
    }

    // MARK: - ViewBuilders
    @ViewBuilder func tasksView() -> some View {
        LazyVStack(spacing: 20) {
            if coreDataViewModel.allTasks.isEmpty {
                Text(strings.noTasks)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .offset(y: 100)
            } else {
                ForEach(coreDataViewModel.allTasks, id: \.id) { task in
                    taskCardView(task: task, isEditing: allTasksViewModel.isEditing)
                }
            }
        }
        .padding()
        .padding(.top)
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
    @ViewBuilder func taskCardView(task: TaskModel, isEditing: Bool) -> some View {
        HStack(alignment: (isEditing ? .center : .top), spacing: 30) {
            if isEditing {
                VStack(spacing: 10) {
                    if task.isCompleted {
                        Button {
                            coreDataViewModel.undoneTask(task: task, date: task.taskDate ?? .now)
                        } label: {
                            Image(systemName: systemImages.xmarkCircleFill)
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    if task.taskDate?.compare(.now) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? .now) {
                        Button {
                            homeViewModel.editTask = task
                            navigationViewModel.showAddingView.toggle()
                        } label: {
                            Image(systemName: systemImages.pencilCircleFill)
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    Button {
                        coreDataViewModel.removeTask(task: task, date: task.taskDate ?? .now) { _ in
                            if coreDataViewModel.allTasks.isEmpty {
                                navigationViewModel.selectedTab = .home
                            }
                        }
                    } label: {
                        Image(systemName: systemImages.minusCircleFill)
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                .transition(.move(edge: .leading).combined(with: .opacity).combined(with: .scale))
            } else {
                VStack(spacing: 10) {
                    Circle()
                        .fill(task.isCompleted ? .green : themeManager.selectedTheme.accentColor)
                        .frame(width: 15, height: 15)
                        .background {
                            Circle()
                                .stroke(themeManager.selectedTheme.accentColor, lineWidth: 1)
                                .padding(-3)
                        }
                        .scaleEffect(1)
                    Rectangle()
                        .fill(themeManager.selectedTheme.accentColor)
                        .frame(width: 3)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity).combined(with: .scale))
            }
            if #available(iOS 17, *), settingsViewModel.shouldShowScrollAnimation {
                taskCard(task: task)
                    .scrollTransition(.animated(.bouncy)) { effect, phase in
                        effect
                            .scaleEffect(phase.isIdentity ? 1 : 0.95)
                            .opacity(phase.isIdentity ? 1 : 0.8)
                            .blur(radius: phase.isIdentity ? 0 : 2)
                            .brightness(phase.isIdentity ? 0 : 0.3)
                    }
            } else {
                taskCard(task: task)
            }
        }
        .hLeading()
        .animation(.spring(), value: task.isCompleted)
    }
    @ViewBuilder func taskCard(task: TaskModel) -> some View {
        VStack {
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(task.taskCategory ?? "Normal")
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    Text(task.taskTitle ?? "Default Title")
                        .font(.title2)
                        .bold()
                    Text(task.taskDescription ?? "Default Description")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .hLeading()
                VStack(alignment: .trailing, spacing: 12) {
                    let taskDate = (task.taskDate ?? Date())
                    Text(taskDate.formatted(date: .omitted, time: .shortened))
                    if !Calendar.current.isDateInToday(taskDate) {
                        Text(taskDate.formatted(date: .abbreviated, time: .omitted))
                    }
                }
            }
                HStack(spacing: 12) {
                    if !task.isCompleted {
                        Button {
                            coreDataViewModel.doneTask(task: task, date: task.taskDate ?? .now)
                        } label: {
                            Image(systemName: systemImages.checkmark)
                                .foregroundStyle(.black)
                                .padding(10)
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    Text(task.isCompleted ? strings.markedAsCompleted : strings.markAsCompleted)
                        .font(.system(size: 15))
                        .foregroundColor(task.isCompleted ? .gray : .white)
                        .hLeading()
                }
                .padding(.top)
        }
        .foregroundColor(.white)
        .padding(16)
        .hLeading()
        .background {
            Color.black.opacity(0.85)
                .cornerRadius(25)
        }
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
