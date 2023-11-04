//
//  HabitCardView.swift
// 

import SwiftUI

struct HabitCardView: View {

    // MARK: - Property Wrappers

    @ObservedObject var habitsViewModel: HabitsViewModel
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    // MARK: - Internal Properties

    let habit: HabitModel

    // MARK: - Body

    var body: some View {
        HStack {
            if habitsViewModel.isEditing {
                VStack {
                    Button {
                        withAnimation {
                            coreDataViewModel.removeHabit(habit: habit) { _ in
                                coreDataViewModel.fetchAllHabits()
                            }
                        }
                    } label: {
                        Image(systemName: ImageNames.System.minusCircleFill)
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    .padding(.trailing, 5)
                }
                .transition(.move(edge: .leading).combined(with: .opacity))
            }

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

                let activePlot = symbols.indices.compactMap { index -> (index: Int, date: Date) in
                    let currentDate = calendar.date(byAdding: .day, value: index, to: startDate)
                    return (index, currentDate ?? .now)
                }

                HStack(spacing: 0) {
                    ForEach(activePlot.indices, id: \.self) { index in
                        let item = activePlot[index]

                        VStack(spacing: 6) {
                            Text(symbols[item.index].prefix(3))
                                .font(.caption)
                                .foregroundStyle(.gray)

                            let status = activeWeekDays.contains { day in
                                day == item.0
                            }

                            Text(getDate(date: item.date))
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
    }

    // MARK: - Private Functions

    func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"

        return formatter.string(from: date)
    }

}
