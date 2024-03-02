//
//  TaskCardView.swift
//

import SwiftUI


struct TaskCard: View {

    // MARK: - Property Wrappers

    @ObservedObject var coreDataManager: CoreDataManager

    @State private var showDetail: Bool = false
    @State private var showCardTap: Bool = false

    // MARK: - Internal Properties

    let taskObject: TaskModel

    var doneImageName: String
    var markAsCompletedName: String
    var markedAsCompletedName: String

    // MARK: - Private Properties

    private let calendar = Calendar.current

    private var isCompleted: Bool {
        taskObject.isCompleted
    }

    private var taskDate: Date {
        taskObject.taskDate ?? .now
    }

    private var isToday: Bool {
        calendar.isDateInToday(taskDate)
    }

    // MARK: - Body

    var body: some View {
        VStack {
            taskInformation()

            isDoneControl()
        }
        .foregroundColor(.white)
        .padding(16)
        .hLeading()
        .background {
            Color.black
                .opacity(showDetail ? 0.95 : 0.85)
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
            ImpactManager.shared.generateFeedback()
            
            withAnimation {
                if isCompleted {
                    coreDataManager.undoneTask(task: taskObject, date: taskObject.taskDate ?? .now)
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

    // MARK: - ViewBuilders

    @ViewBuilder func taskInformation() -> some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    cardTopBar()

                    VStack {
                        if showDetail && !isToday {
                            Text(taskObject.taskCategory ?? "Normal")
                                .transition(.opacity.combined(with: .scale))
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .animation(.spring, value: showDetail)

                    Text(taskObject.taskTitle ?? "Default Title")
                        .font(.title2)
                        .bold()
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .hLeading()

                VStack {
                    if let description = taskObject.taskDescription, 
                        showDetail, description != "" {
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
    }

    @ViewBuilder func isDoneControl() -> some View {
        HStack(spacing: 12) {
            Button {
                if isCompleted {
                    coreDataManager.undoneTask(task: taskObject, date: taskObject.taskDate ?? .now)
                } else {
                    doneTask()
                }
            } label: {
                Image(systemName: doneImageName)
                    .foregroundStyle(.black)
                    .opacity(isCompleted ? 1 : 0.01)
                    .padding(10)
                    .background(
                        Color.white.opacity(isCompleted ? 1 : 0.6),
                        in: RoundedRectangle(cornerRadius: 10)
                    )
            }
            .buttonStyle(HeaderButtonStyle())

            Group {
                if #available(iOS 16, *) {
                    Text(isCompleted ? markedAsCompletedName : markAsCompletedName)
                        .opacity(isCompleted ? 1 : 0.6)
                        .contentTransition(.numericText())
                } else {
                    if isCompleted {
                        Text(markedAsCompletedName)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    } else {
                        Text(markAsCompletedName)
                            .opacity(0.6)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .font(.system(size: 15))
            .foregroundColor(.white)
            .hLeading()
        }
        .padding(.top)
    }

    @ViewBuilder func cardTopBar() -> some View {
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
                    Text(taskObject.taskCategory ?? "Normal")
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .font(.callout)
        .foregroundStyle(.secondary)
        .animation(.spring, value: showDetail)
    }

    // MARK: - Private Functions

    private func doneTask() {
        withAnimation(.spring) {
            coreDataManager.doneTask(task: taskObject, date: taskObject.taskDate ?? .now)
        }

        NotificationManager.shared.removeNotification(with: taskObject.taskID ?? "")
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
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var themeManager: ThemeManager

    @Binding var isEditing: Bool
    @Binding var task: TaskModel

    // MARK: - Internal Properties

    var onRemove: ((Date) -> ())? = nil

    // MARK: - Body

    var body: some View {
        HStack(alignment: (isEditing ? .center : .top), spacing: 30) {
            if isEditing {
                taskCardEditView()
                    .transition(.move(edge: .leading).combined(with: .opacity))
            } else {
                taskCardNotEditView()
                    .transition(.move(edge: .trailing).combined(with: .opacity).combined(with: .scale))
            }

            TaskCard(
                coreDataManager: coreDataManager,
                taskObject: task,
                doneImageName: ImageConstants.System.checkmark,
                markAsCompletedName: Localizable.Home.markAsCompleted,
                markedAsCompletedName: Localizable.Home.markedAsCompleted
            )
            .modifier(ScrollTransitionModifier(condition: $settingsViewModel.shouldShowScrollAnimation))

        }
        .hLeading()
        .animation(.spring, value: task.isCompleted)
    }

    // MARK: - ViewBuilders

    @ViewBuilder func taskCardEditView() -> some View {
        VStack(spacing: 10) {
            if task.isCompleted {
                Button {
                    withAnimation(.spring) {
                        coreDataManager.undoneTask(task: task, date: task.taskDate ?? .now)
                    }

                    if task.shouldNotificate {
                        sendNotification(task: task)
                    }
                } label: {
                    Image(systemName: ImageConstants.System.xmarkCircleFill)
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }

            if task.taskDate?.compare(.now) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? .now) {
                Button {
                    homeViewModel.editTask = task
                    navigationViewModel.showTaskAddingView.toggle()
                } label: {
                    Image(systemName: ImageConstants.System.pencilCircleFill)
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }

            Button {
                withAnimation {
                    coreDataManager.removeTask(task: task) { taskDate in
                        self.onRemove?(taskDate)

                        if coreDataManager.allTasks.isEmpty {
                            navigationViewModel.showAllTasksView = false
                        }
                    }
                }
            } label: {
                Image(systemName: ImageConstants.System.minusCircleFill)
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
    }

    @ViewBuilder func taskCardNotEditView() -> some View {
        VStack(spacing: 10) {
            Circle()
                .fill(
                    themeManager.selectedTheme.accentColor
                        .opacity(task.isCompleted ? 1 : 0.1)
                )
                .frame(width: 15, height: 15)
                .background {
                    Circle()
                        .stroke(
                            themeManager.selectedTheme.accentColor,
                            lineWidth: 1
                        )
                        .padding(-3)
                }
                .scaleEffect(task.isCompleted ? 1.1 : 1)
                .onTapGesture {
                    withAnimation(.spring) {
                        if task.isCompleted {
                            withAnimation(.spring) {
                                coreDataManager.undoneTask(task: task, date: task.taskDate ?? .now)
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
