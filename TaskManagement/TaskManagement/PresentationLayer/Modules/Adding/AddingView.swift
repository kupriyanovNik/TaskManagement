//
//  AddingView.swift
//

import SwiftUI

struct AddingView: View {

    // MARK: - Property Wrappers
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var addingViewModel: AddingViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties
    private var strings = Localizable.Adding.self
    private var systemImages = ImageNames.System.self

    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                CustomTextField(
                    inputText: $addingViewModel.taskTitle,
                    placeHolder: strings.taskTitle,
                    strokeColor: themeManager.selectedTheme.accentColor
                )
                CustomTextField(
                    inputText: $addingViewModel.taskDescription,
                    placeHolder: strings.taskDescription,
                    strokeColor: themeManager.selectedTheme.accentColor
                )
                if homeViewModel.editTask == nil {
                    TaskCategorySelector(
                        taskCategory: $addingViewModel.taskCategory,
                        accentColor: themeManager.selectedTheme.accentColor
                    )
                    DatePicker("", selection: $addingViewModel.taskDate, in: Date()...)
                        .datePickerStyle(.graphical)
                        .tint(themeManager.selectedTheme.accentColor)
                        .labelsHidden()
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(themeManager.selectedTheme.accentColor, lineWidth: 1)
                        }
                    HStack {
                        Text(strings.shouldRemind)
                        Spacer()
                        RadioButton(
                            isSelected: $addingViewModel.shouldSendNotification,
                            accentColor: themeManager.selectedTheme.accentColor
                        )
                        .frame(width: 30, height: 30)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(themeManager.selectedTheme.accentColor, lineWidth: 1)
                    }
                }
            }
            .padding()
        }
        .makeCustomNavBar {
            headerView()
        }
        .onAppear {
            if let task = homeViewModel.editTask {
                addingViewModel.taskTitle = task.taskTitle ?? ""
                addingViewModel.taskDescription = task.taskDescription ?? ""
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
                    .rotationEffect(.degrees(270))
            }
            Text(strings.title)
                .bold()
                .font(.largeTitle)
                .foregroundStyle(themeManager.selectedTheme.pageTitleColor)
            Spacer()
            if !addingViewModel.taskTitle.isEmpty {
                Button {
                    saveAction()
                } label: {
                    Text(strings.save)
                        .foregroundStyle(themeManager.selectedTheme.accentColor)
                }
                .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
            }
        }
        .animation(.linear, value: addingViewModel.taskTitle)
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding([.horizontal, .top])
    }

    // MARK: - Private Functions
    private func saveAction() {
        if let task = homeViewModel.editTask {
            coreDataViewModel.updateTask(
                task: task,
                title: addingViewModel.taskTitle,
                description: addingViewModel.taskDescription
            )
        } else {
            coreDataViewModel.addTask(
                title: addingViewModel.taskTitle,
                description: addingViewModel.taskDescription,
                date: addingViewModel.taskDate,
                category: addingViewModel.taskCategory
            ) {
                homeViewModel.currentDay = $0
            }
            if addingViewModel.shouldSendNotification {
                sendNotification()
            }
        }
        dismiss()
    }
    private func sendNotification() {
        let date = addingViewModel.taskDate
        let body = addingViewModel.taskTitle
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        let hour = calendar.component(.hour, from: date)
        let day = calendar.component(.day, from: date)
        NotificationManager.shared.sendNotification(
            id: UUID().uuidString,
            minute: minute,
            hour: hour,
            day: day,
            title: date.greeting(),
            subtitle: strings.unfinishedTask,
            body: body,
            isCritical: addingViewModel.taskCategory == .critical ? true : false 
        )
    }
}

#Preview {
    AddingView()
        .environmentObject(HomeViewModel())
        .environmentObject(NavigationViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(AddingViewModel())
        .environmentObject(ThemeManager())
}
