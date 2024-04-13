//
//  AddingView.swift
//

import SwiftUI

struct TaskAddingView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var homeViewModel: HomeViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var taskAddingViewModel: TaskAddingViewModel
    @ObservedObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private let strings = Localizable.TaskAdding.self
    private let systemImages = ImageConstants.System.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                CustomTextField(
                    inputText: $taskAddingViewModel.taskTitle,
                    placeHolder: strings.taskTitle,
                    strokeColor: themeManager.selectedTheme.accentColor
                )
                .onTapContinueEditing()

                CustomTextField(
                    inputText: $taskAddingViewModel.taskDescription,
                    placeHolder: strings.taskDescription,
                    strokeColor: themeManager.selectedTheme.accentColor
                )
                .onTapContinueEditing()

                if homeViewModel.editTask != nil, NotificationManager.shared.isNotificationEnabled == true {
                    HStack {
                        Text(strings.shouldRemind)

                        Spacer()

                        RadioButton(
                            isSelected: $taskAddingViewModel.shouldSendNotification,
                            accentColor: themeManager.selectedTheme.accentColor
                        )
                        .frame(width: 30, height: 30)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(themeManager.selectedTheme.accentColor, lineWidth: 1)
                    }
                    .onTapEndEditing()
                }

                if homeViewModel.editTask == nil {
                    TaskCategorySelector(
                        taskCategory: $taskAddingViewModel.taskCategory,
                        accentColor: themeManager.selectedTheme.accentColor
                    )

                    VStack {
                        DatePicker(
                            "",
                            selection: $taskAddingViewModel.taskDate,
                            in: Date()...
                        )
                        .datePickerStyle(.graphical)
                        .tint(themeManager.selectedTheme.accentColor)
                        .labelsHidden()
                        .padding(.horizontal)
                        .padding(.bottom, 5)

                        Rectangle()
                            .fill(themeManager.selectedTheme.accentColor)
                            .frame(height: 1)

                        if NotificationManager.shared.isNotificationEnabled == true {
                            HStack {
                                Text(strings.shouldRemind)

                                Spacer()

                                RadioButton(
                                    isSelected: $taskAddingViewModel.shouldSendNotification,
                                    accentColor: themeManager.selectedTheme.accentColor
                                )
                                .frame(width: 30, height: 30)
                            }
                            .padding([.horizontal, .bottom])
                            .padding(.top, 5)
                            .onTapEndEditing()
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                themeManager.selectedTheme.accentColor,
                                lineWidth: 1
                            )
                            .onTapEndEditing()
                    }
                }
            }
            .padding()
        }
        .makeCustomNavBar {
            headerView()
                .onTapEndEditing()
        }
        .onAppear {
            if let task = homeViewModel.editTask {
                taskAddingViewModel.taskTitle = task.taskTitle ?? ""
                taskAddingViewModel.taskDescription = task.taskDescription ?? ""
                taskAddingViewModel.shouldSendNotification = task.shouldNotificate
            }
        }
        .onChange(of: taskAddingViewModel.taskDate) { _ in
            hideKeyboard()
        }
        .onChange(of: taskAddingViewModel.taskCategory) { _ in
            hideKeyboard()
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func headerView() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: systemImages.backArrow)
                    .foregroundColor(.black)
                    .font(.title2)
                    .rotationEffect(.degrees(270))
            }

            Text(strings.title)
                .bold()
                .font(.title)
                .foregroundStyle(themeManager.selectedTheme.pageTitleColor)

            Spacer()

            if !taskAddingViewModel.taskTitle.isEmpty {
                Button {
                    saveAction()
                } label: {
                    Text(strings.save)
                        .foregroundStyle(themeManager.selectedTheme.accentColor)
                }
                .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
            }
        }
        .animation(.linear, value: taskAddingViewModel.taskTitle)
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding([.horizontal, .top])
    }

    // MARK: - Private Functions

    private func saveAction() {
        if let task = homeViewModel.editTask {
            coreDataManager.updateTask(
                task: task,
                title: taskAddingViewModel.taskTitle,
                description: taskAddingViewModel.taskDescription,
                shouldNotificate: taskAddingViewModel.shouldSendNotification
            )

            NotificationManager.shared.removeNotification(with: task.taskID ?? "")

            if taskAddingViewModel.shouldSendNotification {
                sendNotification(
                    id: task.taskID ?? "",
                    date: task.taskDate ?? .now,
                    body: task.taskTitle ?? ""
                )
            }
        } else {
            coreDataManager.addTask(
                id: UUID().uuidString,
                title: taskAddingViewModel.taskTitle,
                description: taskAddingViewModel.taskDescription,
                date: taskAddingViewModel.taskDate,
                category: taskAddingViewModel.taskCategory,
                shouldNotificate: taskAddingViewModel.shouldSendNotification
            ) { date, task in
                homeViewModel.currentDay = date

                if taskAddingViewModel.shouldSendNotification {
                    sendNotification(
                        id: task.taskID ?? "",
                        date: taskAddingViewModel.taskDate,
                        body: taskAddingViewModel.taskTitle
                    )
                }
            }
        }
        
        dismiss()
    }

    private func sendNotification(id: String, date: Date, body: String) {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        let hour = calendar.component(.hour, from: date)
        let day = calendar.component(.day, from: date)

        NotificationManager.shared.sendNotification(
            id: id,
            minute: minute,
            hour: hour,
            day: day,
            title: date.greeting(),
            subtitle: strings.unfinishedTask,
            body: body,
            isCritical: taskAddingViewModel.taskCategory == .important
        )
    }
}

// MARK: - Preview

#Preview {
    TaskAddingView(
        homeViewModel: .init(),
        navigationManager: .init(),
        coreDataManager: .init(),
        taskAddingViewModel: .init(),
        themeManager: .init()
    )
}
