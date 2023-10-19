//
//  TaskCardView.swift
//

import SwiftUI


struct TaskCard: View {

    // MARK: - Property Wrappers

    @ObservedObject var coreDataViewModel: CoreDataViewModel

    // MARK: - Internal Properties

    let task: TaskModel
    var doneImageName: String
    var markAsCompletedName: String
    var markedAsCompletedName: String

    // MARK: - Body

    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(task.taskCategory ?? "Normal")
                            .font(.callout)
                            .foregroundStyle(.secondary)

                        Text(task.taskTitle ?? "Default Title")
                            .font(.title2)
                            .bold()
                    }
                    .hLeading()

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
                        Image(systemName: doneImageName)
                            .foregroundStyle(.black)
                            .padding(10)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                    }
                }

                Text(task.isCompleted ? markedAsCompletedName : markAsCompletedName)
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

struct TaskCardView: View {

    // MARK: - Property Wrappers

    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var navigationViewModel: NavigationViewModel
    @ObservedObject var coreDataViewModel: CoreDataViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var themeManager: ThemeManager

    @Binding var isEditing: Bool
    @Binding var task: TaskModel

    // MARK: - Body

    var body: some View {
        HStack(alignment: (isEditing ? .center : .top), spacing: 30) {
            if isEditing {
                VStack(spacing: 10) {
                    if task.isCompleted {
                        Button {
                            coreDataViewModel.undoneTask(task: task, date: task.taskDate ?? .now)
                        } label: {
                            Image(systemName: ImageNames.System.xmarkCircleFill)
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }

                    if task.taskDate?.compare(.now) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? .now) {
                        Button {
                            homeViewModel.editTask = task
                            navigationViewModel.showAddingView.toggle()
                        } label: {
                            Image(systemName: ImageNames.System.pencilCircleFill)
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
                        Image(systemName: ImageNames.System.minusCircleFill)
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

                    Rectangle()
                        .fill(themeManager.selectedTheme.accentColor)
                        .frame(width: 3)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity).combined(with: .scale))
            }
            
            if #available(iOS 17, *), settingsViewModel.shouldShowScrollAnimation {
                TaskCard(
                    coreDataViewModel: coreDataViewModel,
                    task: task,
                    doneImageName: ImageNames.System.checkmark,
                    markAsCompletedName: Localizable.Home.markAsCompleted,
                    markedAsCompletedName: Localizable.Home.markedAsCompleted
                )
                .scrollTransition(.animated(.bouncy)) { effect, phase in
                    effect
                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                        .opacity(phase.isIdentity ? 1 : 0.8)
                        .blur(radius: phase.isIdentity ? 0 : 2)
                        .brightness(phase.isIdentity ? 0 : 0.3)
                }
            } else {
                TaskCard(
                    coreDataViewModel: coreDataViewModel,
                    task: task,
                    doneImageName: ImageNames.System.checkmark,
                    markAsCompletedName: Localizable.Home.markAsCompleted,
                    markedAsCompletedName: Localizable.Home.markedAsCompleted
                )
            }
        }
        .hLeading()
        .animation(.spring(), value: task.isCompleted)
    }
}
