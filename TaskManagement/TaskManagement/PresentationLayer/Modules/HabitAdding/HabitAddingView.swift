//
//  HabitAddingView.swift
//

import SwiftUI

struct HabitAddingView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var habitAddingViewModel: HabitAddingViewModel
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
                    placeHolder: "Habit Title",
                    strokeColor: themeManager.selectedTheme.accentColor
                )
                .continueEditing()

                CustomTextField(
                    inputText: $habitAddingViewModel.habitDescription,
                    placeHolder: "Habit Description",
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
                                    Image(systemName: "checkmark")
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
                    Text("Frequency")
                        .font(.callout.bold())


                    HStack {
                        ForEach(habitAddingViewModel.currentWeek, id: \.self) { weekDay in
                            let dayOfWeek = habitAddingViewModel.extractDate(
                                date: weekDay,
                                format: Constants.DateFormats.forDateLiteral
                            )

                            let index = habitAddingViewModel.weekDays.firstIndex { value in
                                return value == dayOfWeek
                            } ?? -1

                            let insIndex = habitAddingViewModel.weekDays.firstIndex {
                                $0 == dayOfWeek
                            } ?? -1

                            let isSelected = habitAddingViewModel.weekDays.contains(dayOfWeek)

                            let selectedColor = habitAddingViewModel.habitColor.toColor()

                            Text(dayOfWeek.prefix(3))
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(isSelected ? selectedColor : .gray.opacity(0.4))
                                        .animation(.linear.delay(Double(insIndex) * 0.05), value: habitAddingViewModel.habitColor)

                                }
                                .scaleEffect(isSelected ? 1 : 0.9)
                                .onTapGesture {
                                    withAnimation {
                                        if index != -1 {
                                            habitAddingViewModel.weekDays.remove(at: index)
                                        } else {
                                            habitAddingViewModel.weekDays.append(dayOfWeek)
                                        }
                                    }
                                }
                                .animation(.smooth(extraBounce: 0.5), value: habitAddingViewModel.weekDays)
                        }
                    }
                    .padding(.top, 15)
                }
                .padding(.vertical)

                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Remainder")
                            .fontWeight(.semibold)

                        Text("Just Notifications")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Toggle(isOn: $habitAddingViewModel.isRemainderOn) { }
                        .labelsHidden()
                        .tint(themeManager.selectedTheme.accentColor)
                }
                .padding(.vertical)

                if habitAddingViewModel.isRemainderOn {
                    HStack(spacing: 12) {
                        Label {
                            Text(habitAddingViewModel.remainderDate.formatted(date: .omitted, time: .shortened))
                        } icon: {
                            Image(systemName: "clock")
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
                            inputText: $habitAddingViewModel.remainderText,
                            placeHolder: "Remainder Text",
                            strokeColor: themeManager.selectedTheme.accentColor
                        )
                        .continueEditing()
                        .padding(.horizontal)

                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.smooth(extraBounce: 0.5), value: habitAddingViewModel.isRemainderOn)
            .padding()
        }
        .onAppear {
            habitAddingViewModel.fetchCurrentWeek()
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
                        selection: $habitAddingViewModel.remainderDate,
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
                    Text("Save")
                        .foregroundStyle(themeManager.selectedTheme.accentColor)
                }
                .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
            }
        }
        .animation(.bouncy, value: habitAddingViewModel.isRemainderOn)
        .animation(.bouncy, value: habitAddingViewModel.remainderText)
        .animation(.bouncy, value: habitAddingViewModel.habitTitle)
        .animation(.bouncy, value: habitAddingViewModel.weekDays.isEmpty)
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding([.horizontal, .top])
    }

    // MARK: - Private Functions

    private func saveAction() {
        
        dismiss()
    }

}

// MARK: - Preview

#Preview {
    HabitAddingView()
        .environmentObject(HabitAddingViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(ThemeManager())
}
