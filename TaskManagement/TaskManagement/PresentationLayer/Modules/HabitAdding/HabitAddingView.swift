//
//  HabitAddingView.swift
//

import SwiftUI

struct HabitAddingView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var habitAddingViewModel: HabitAddingViewModel
    @EnvironmentObject var habitsViewModel: HabitsViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties

    private var systemImages = ImageNames.System.self
    private var strings = Localizable.HabitAdding.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                CustomTextField(
                    inputText: $habitAddingViewModel.habitTitle,
                    placeHolder: strings.habitTitle,
                    strokeColor: themeManager.selectedTheme.accentColor
                )
                .continueEditing()

                CustomTextField(
                    inputText: $habitAddingViewModel.habitDescription,
                    placeHolder: strings.habitDescription,
                    strokeColor: themeManager.selectedTheme.accentColor
                )
                .continueEditing()

                HStack {
                    ForEach(1..<7) { index in
                        let color = "Card-\(index)"

                        Circle()
                            .fill(color.toColor())
                            .frame(width: 35, height: 35)
                            .overlay {
                                if color == habitAddingViewModel.habitColor {
                                    Image(systemName: systemImages.checkmark)
                                        .transition(
                                            .asymmetric(
                                                insertion: .scale,
                                                removal: .opacity
                                            )
                                        )
                                }
                            }
                            .overlay {
                                if color == habitAddingViewModel.habitColor {
                                    Circle()
                                        .stroke(color.toColor(), lineWidth: 2)
                                        .scaleEffect(1.2)
                                }
                            }
                            .animation(.smooth(extraBounce: 0.5), value: habitAddingViewModel.habitColor)
                            .onTapGesture {
                                habitAddingViewModel.habitColor = color
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical)

                VStack(alignment: .leading, spacing: 6) {
                    Text(strings.frequency)
                        .font(.callout.bold())

                    let weekDays = Calendar.current.weekdaySymbols

                    HStack {
                        ForEach(weekDays, id: \.self) { dayOfWeek in
                            let index = weekDays.firstIndex {
                                $0 == dayOfWeek
                            } ?? -1

                            let isSelected = habitAddingViewModel.weekDaysIndicies.contains(index)

                            let selectedColor = habitAddingViewModel.habitColor.toColor()

                            Text(dayOfWeek.prefix(3))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(isSelected ? selectedColor : .gray.opacity(0.4))
                                        .animation(
                                            .linear.delay(Double(index) * 0.05),
                                            value: habitAddingViewModel.habitColor
                                        )

                                }
                                .scaleEffect(isSelected ? 1 : 0.9)
                                .onTapGesture {
                                    withAnimation {
                                        if let firstIndex = habitAddingViewModel.weekDaysIndicies.firstIndex(of: index) {
                                            habitAddingViewModel.weekDaysIndicies.remove(at: firstIndex)
                                        } else {
                                            habitAddingViewModel.weekDaysIndicies.append(index)
                                        }
                                    }
                                }
                                .animation(.smooth(extraBounce: 0.5), value: habitAddingViewModel.weekDaysIndicies)
                        }
                    }
                    .padding(.top, 15)
                }
                .padding(.vertical)

                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(strings.reminder)
                            .fontWeight(.semibold)

                        Text(strings.justNotifications)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Toggle(isOn: $habitAddingViewModel.shouldNotificate) { }
                        .labelsHidden()
                        .tint(themeManager.selectedTheme.accentColor)
                }
                .padding(.vertical)

                if habitAddingViewModel.shouldNotificate {
                    HStack(spacing: 12) {
                        Label {
                            Text(habitAddingViewModel.reminderDate.formatted(date: .omitted, time: .shortened))
                        } icon: {
                            Image(systemName: systemImages.clock)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(
                            themeManager.selectedTheme.accentColor.opacity(0.2),
                            in: RoundedRectangle(cornerRadius: 10)
                        )
                        .onTapGesture {
                            withAnimation {
                                habitAddingViewModel.showTimePicker.toggle()
                            }
                        }

                        CustomTextField(
                            inputText: $habitAddingViewModel.reminderText,
                            placeHolder: strings.reminderText,
                            strokeColor: themeManager.selectedTheme.accentColor
                        )
                        .continueEditing()
                        .padding(.horizontal)

                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.smooth(extraBounce: 0.5), value: habitAddingViewModel.shouldNotificate)
            .padding()
        }
        .onAppear {
            if let habit = habitsViewModel.editHabit {
                habitAddingViewModel.habitTitle = habit.title ?? ""
                habitAddingViewModel.habitDescription = habit.habitDescription ?? ""
                habitAddingViewModel.habitColor = habit.color ?? ""
                habitAddingViewModel.weekDaysIndicies = habit.weekDays ?? []
                habitAddingViewModel.shouldNotificate = habit.isReminderOn
                habitAddingViewModel.reminderText = habit.reminderText ?? ""
            }
        }
        .makeCustomNavBar {
            headerView()
        }
        .endEditing()
        .overlay {
            if habitAddingViewModel.showTimePicker {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                habitAddingViewModel.showTimePicker.toggle()
                            }
                        }

                    DatePicker(
                        "",
                        selection: $habitAddingViewModel.reminderDate,
                        displayedComponents: [.hourAndMinute]
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(themeManager.selectedTheme.accentColor.opacity(0.2))
                    }
                    .padding()
                }
            }
        }
    }

    // MARK: - View Builders

    @ViewBuilder func headerView() -> some View {
        let isAbleToSave = habitAddingViewModel.isAbleToSave()

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

            if isAbleToSave {
                Button {
                    saveAction()
                } label: {
                    Text(strings.save)
                        .foregroundStyle(themeManager.selectedTheme.accentColor)
                }
                .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
            }
        }
        .animation(.bouncy, value: isAbleToSave)
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding([.horizontal, .top])
    }

    // MARK: - Private Functions

    private func saveAction() {
        if let habit = habitsViewModel.editHabit {
            if habitAddingViewModel.shouldNotificate {
                NotificationManager.shared.removeNotification(with: habit.habitID ?? "")

                habit.notificationIDs = NotificationManager.shared.cheduleNotification(
                    title: strings.notificationTitle,
                    subtitle: habitAddingViewModel.reminderText.removeLeadingSpacing(),
                    weekDays: habitAddingViewModel.weekDaysIndicies,
                    reminderDate: habitAddingViewModel.reminderDate
                )
            } else {
                if habit.isReminderOn {
                    NotificationManager.shared.removeNotification(with: habit.habitID ?? "")
                }
            }

            coreDataViewModel.updateHabit(
                habit: habit,
                title: habitAddingViewModel.habitTitle.removeLeadingSpacing(),
                description: habitAddingViewModel.habitDescription,
                weekDays: habitAddingViewModel.weekDaysIndicies,
                color: habitAddingViewModel.habitColor,
                shouldNotificate: habitAddingViewModel.shouldNotificate,
                reminderText: habitAddingViewModel.reminderText
            )
        } else {
            coreDataViewModel.addHabit(
                id: UUID().uuidString,
                title: habitAddingViewModel.habitTitle.removeLeadingSpacing(),
                description: habitAddingViewModel.habitDescription,
                color: habitAddingViewModel.habitColor,
                shouldNotificate: habitAddingViewModel.shouldNotificate,
                notificationIDs: NotificationManager.shared.cheduleNotification(
                    title: strings.notificationTitle.removeLeadingSpacing(),
                    subtitle: habitAddingViewModel.reminderText.removeLeadingSpacing(),
                    weekDays: habitAddingViewModel.weekDaysIndicies,
                    reminderDate: habitAddingViewModel.reminderDate
                ),
                notificationText: habitAddingViewModel.reminderText.removeLeadingSpacing(),
                weekDays: habitAddingViewModel.weekDaysIndicies
            )
        }

        dismiss()
    }

}

// MARK: - Preview

#Preview {
    HabitAddingView()
        .environmentObject(HabitAddingViewModel())
        .environmentObject(HabitsViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(ThemeManager())
}
