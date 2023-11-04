//
//  HabitsView.swift
//

import SwiftUI

struct HabitsView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var habitsViewModel: HabitsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                if coreDataViewModel.allHabits.isEmpty {
                    NotFoundView(
                        title: "No Habits Found",
                        description: "Here you will your habits.\nHold \"+\" to add a new one",
                        accentColor: themeManager.selectedTheme.accentColor
                    )
                } else {
                    ForEach(coreDataViewModel.allHabits, id: \.habitID) { habit in
                        if #available(iOS 17, *), settingsViewModel.shouldShowScrollAnimation {
                            HabitCardView(habit: habit)
                                .scrollTransition(.animated(.bouncy)) { effect, phase in
                                    effect
                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                        .opacity(phase.isIdentity ? 1 : 0.8)
                                        .blur(radius: phase.isIdentity ? 0 : 2)
                                        .brightness(phase.isIdentity ? 0 : 0.3)
                                }
                        } else {
                            HabitCardView(habit: habit)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            delay(3) {
                withAnimation(.default) {
                    habitsViewModel.showGreetings = false
                }
            }
        }
        .makeCustomNavBar {
            headerView()
        }
    }

    // MARK: - View Builders

    @ViewBuilder func HabitCardView(habit: HabitModel) -> some View {
        VStack(spacing: 6) {
            HStack {
                Text(habit.title ?? "Default Title")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                Image(systemName: "bell.badge.fill")
                    .font(.callout)
                    .foregroundColor((habit.color ?? "Card-1").toColor())
                    .scaleEffect(0.9)
                    .opacity(habit.isReminderOn ? 1 : 0)

                Spacer()

                let count = (habit.weekDays?.count ?? 0)
                Text( count == 7 ? "Everyday" : "\(count) times a week")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 10)

            Text(habit.habitDescription ?? "Default Description")
                .font(.callout)
                .foregroundStyle(.secondary)
                .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
                .lineLimit(nil)
                .hLeading()
                .padding(.horizontal, 10)

            let calendar = Calendar.current
            let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: .now)
            let symbols = calendar.weekdaySymbols
            let startDate = currentWeek?.start ?? .now

            let activeWeekDays = habit.weekDays ?? []

            let activePlot = symbols.indices.compactMap { index -> (Int, Date) in
                let currentDate = calendar.date(byAdding: .day, value: index, to: startDate)
                return (index, currentDate ?? .now)
            }

            HStack(spacing: 0) {
                ForEach(activePlot.indices, id: \.self) { index in
                    let item = activePlot[index]

                    VStack(spacing: 6) {
                        Text(symbols[item.0].prefix(3))
                            .font(.caption)
                            .foregroundStyle(.gray)

                        let status = activeWeekDays.contains { day in
                            day == item.0
                        }

                        Text(getDate(date: item.1))
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .padding(8)
                            .background {
                                Circle()
                                    .fill(habit.color?.toColor() ?? "Card-1".toColor())
                                    .opacity(status ? 1 : 0)
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 15)
        }
        .padding(.vertical)
        .padding(.horizontal, 6)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
        }
    }

    func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"

        return formatter.string(from: date)
    }

    @ViewBuilder func headerView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    if habitsViewModel.showGreetings {
                        Text("✅")
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }

                    Text("Get Better")
                        .foregroundColor(.gray)
                }

                Text("Habits")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(themeManager.selectedTheme.pageTitleColor)
            }

            Spacer()

            if !coreDataViewModel.allHabits.isEmpty {
                Group {
                    if habitsViewModel.isEditing {
                        Button("Done") {
                            withAnimation {
                                habitsViewModel.isEditing.toggle()
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .scale))
                    } else {
                        Button("Edit") {
                            withAnimation {
                                habitsViewModel.isEditing.toggle()
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

// MARK: - Preview

#Preview {
    HabitsView()
        .environmentObject(HabitsViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(ThemeManager())
}
