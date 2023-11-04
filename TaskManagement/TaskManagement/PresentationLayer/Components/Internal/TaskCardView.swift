//
//  TaskCardView.swift
//

import SwiftUI


struct TaskCard: View {

    // MARK: - Property Wrappers

    @ObservedObject var coreDataViewModel: CoreDataViewModel

    @State private var showDetail: Bool = false
    @State private var showCardTap: Bool = false

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
                    let taskDate = (task.taskDate ?? Date())
                    let isToday = Calendar.current.isDateInToday(taskDate)

                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 10) {
                            if isToday {
                                Text(taskDate.formatted(date: .omitted, time: .shortened))
                                    .foregroundColor(.white.opacity(showDetail ? 1 : 0.7))
                            }

                            if showDetail && !isToday {
                                Text(taskDate.formatted(date: .omitted, time: .shortened))
                                    .transition(.opacity.combined(with: .scale))
                                    .foregroundColor(.white)
                            }

                            if !isToday {
                                Text(taskDate.formatted(date: .abbreviated, time: .omitted))
                                    .transition(.opacity.combined(with: .scale))
                            }

                            VStack {
                                if showDetail && isToday {
                                    Text(task.taskCategory ?? "Normal")
                                        .transition(.opacity.combined(with: .scale))
                                }
                            }
                        }
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .animation(.spring, value: showDetail)

                        VStack {
                            if showDetail && !isToday {
                                Text(task.taskCategory ?? "Normal")
                                    .transition(.opacity.combined(with: .scale))
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .animation(.spring, value: showDetail)

                        Text(task.taskTitle ?? "Default Title")
                            .font(.title2)
                            .bold()
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .hLeading()

                    VStack {
                        if showDetail, let description = task.taskDescription {
                            Text(description)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
                                .lineLimit(nil)
                        }
                    }
                    .animation(.spring, value: showDetail)
                }
                .hLeading()
            }

            HStack(spacing: 12) {
                if !task.isCompleted {
                    Button {
                        doneTask()
                    } label: {
                        Image(systemName: doneImageName)
                            .foregroundStyle(.black)
                            .padding(10)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
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
            Color.black
                .opacity(0.85)
                .cornerRadius(showDetail ? 15 : 25)
        }
        .scaleEffect(showCardTap ? 0.95 : 1)
        .scaleEffect(showDetail ? 1.05 : 1)
        .onTapGesture {
            withAnimation(.easeOut) {
                showDetail.toggle()
            }
        }
        .onLongPressGesture(minimumDuration: 0.7, maximumDistance: 50) {
            withAnimation {
                generateFeedback()

                if task.isCompleted {
                    coreDataViewModel.undoneTask(task: task, date: task.taskDate ?? .now)
                } else {
                    doneTask()
                }
            }
        } onPressingChanged: { isPressed in
            withAnimation {
                showCardTap = isPressed
            }
        }
    }

    // MARK: - Private Functions

    private func doneTask() {
        withAnimation(.spring) {
            coreDataViewModel.doneTask(task: task, date: task.taskDate ?? .now)
        }
        NotificationManager.shared.removeNotification(with: task.taskID ?? "")
    }

    private func sendNotification(task: TaskModel) {
        let date = task.taskDate ?? .now
        let body = task.taskTitle ?? ""
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        let hour = calendar.component(.hour, from: date)
        let day = calendar.component(.day, from: date)

        if task.shouldNotificate {
            NotificationManager.shared.sendNotification(
                id: task.taskID ?? "",
                minute: minute,
                hour: hour,
                day: day,
                title: date.greeting(),
                subtitle: Localizable.TaskAdding.unfinishedTask,
                body: body,
                isCritical: (task.taskCategory == "Normal" || task.taskCategory == "Обычное" ) ? false : true
            )
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

    // MARK: - Internal Properties

    var onRemove: (() -> ())? = nil

    // MARK: - Body

    var body: some View {
        HStack(alignment: (isEditing ? .center : .top), spacing: 30) {
            if isEditing {
                VStack(spacing: 10) {
                    if task.isCompleted {
                        Button {
                            withAnimation(.spring) {
                                coreDataViewModel.undoneTask(task: task, date: task.taskDate ?? .now)
                            }
                            if task.shouldNotificate {
                                sendNotification(task: task)
                            }
                        } label: {
                            Image(systemName: ImageNames.System.xmarkCircleFill)
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }

                    if task.taskDate?.compare(.now) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? .now) {
                        Button {
                            homeViewModel.editTask = task
                            navigationViewModel.showTaskAddingView.toggle()
                        } label: {
                            Image(systemName: ImageNames.System.pencilCircleFill)
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }

                    Button {
                        coreDataViewModel.removeTask(task: task) { _ in
                            self.onRemove?()
                            if coreDataViewModel.allTasks.isEmpty {
                                navigationViewModel.showAllTasksView = false
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
                        .onTapGesture {
                            withAnimation(.spring) {
                                if task.isCompleted {
                                    withAnimation(.spring) {
                                        coreDataViewModel.undoneTask(task: task, date: task.taskDate ?? .now)
                                    }
                                    if task.shouldNotificate {
                                        sendNotification(task: task)
                                    }
                                }
                            }
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
        .animation(.spring, value: task.isCompleted)
    }

    // MARK: - Private Functions

    private func sendNotification(task: TaskModel) {
        let date = task.taskDate ?? .now
        let body = task.taskTitle ?? ""
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        let hour = calendar.component(.hour, from: date)
        let day = calendar.component(.day, from: date)

        NotificationManager.shared.sendNotification(
            id: task.taskID ?? "",
            minute: minute,
            hour: hour,
            day: day,
            title: date.greeting(),
            subtitle: Localizable.TaskAdding.unfinishedTask,
            body: body,
            isCritical: (task.taskCategory == "Normal" || task.taskCategory == "Обычное" ) ? false : true
        )
    }
}
