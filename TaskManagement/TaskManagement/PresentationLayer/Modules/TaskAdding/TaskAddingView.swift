//
//  AddingView.swift
//

import SwiftUI

struct TaskAddingView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var taskAddingViewModel: TaskAddingViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties

    private var strings = Localizable.TaskAdding.self
    private var systemImages = ImageNames.System.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                CustomTextField(
                    inputText: $taskAddingViewModel.taskTitle,
                    placeHolder: strings.taskTitle,
                    strokeColor: themeManager.selectedTheme.accentColor
                )
                .continueEditing()

                CustomTextField(
                    inputText: $taskAddingViewModel.taskDescription,
                    placeHolder: strings.taskDescription,
                    strokeColor: themeManager.selectedTheme.accentColor
                )
                .continueEditing()

                if homeViewModel.editTask != nil {
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
                    .endEditing()
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
                        .endEditing()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                themeManager.selectedTheme.accentColor,
                                lineWidth: 1
                            )
                            .endEditing()
                    }
                }
            }
            .padding()
        }
        .makeCustomNavBar {
            headerView()
                .endEditing()
        }
        .onAppear {
            if let task = homeViewModel.editTask {
                taskAddingViewModel.taskTitle = task.taskTitle ?? ""
                taskAddingViewModel.taskDescription = task.taskDescription ?? ""
                taskAddingViewModel.shouldSendNotification = task.shouldNotificate
            }
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
            coreDataViewModel.updateTask(
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
            coreDataViewModel.addTask(
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
            isCritical: taskAddingViewModel.taskCategory == .critical ? true : false
        )
    }
}

// MARK: - Preview

#Preview {
    TaskAddingView()
        .environmentObject(HomeViewModel())
        .environmentObject(NavigationViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(TaskAddingViewModel())
        .environmentObject(ThemeManager())
}
