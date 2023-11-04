//
//  HabitCardView.swift
//

import SwiftUI

struct HabitCardView: View {

    // MARK: - Property Wrappers

    @ObservedObject var habitsViewModel: HabitsViewModel
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    @State private var showDetail: Bool = false

    // MARK: - Internal Properties

    let habit: HabitModel

    var editAction: ((HabitModel) -> ())? = nil

    // MARK: - Body

    var body: some View {
        HStack {
            let calendar = Calendar.current
            let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: .now)
            let symbols = calendar.weekdaySymbols
            let startDate = currentWeek?.start ?? .now

            let activeWeekDays = habit.weekDays ?? []

            let activePlot = symbols.indices.compactMap { index -> (index: Int, date: Date) in
                let currentDate = calendar.date(byAdding: .day, value: index, to: startDate)
                return (index, currentDate ?? .now)
            }

            if habitsViewModel.isEditing {
                VStack(spacing: 10) {
                    Button {
                        editAction?(habit)
                    } label: {
                        Image(systemName: ImageNames.System.pencilCircleFill)
                            .font(.title2)
                            .foregroundColor(.primary)
                    }

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
                }
                .padding(.trailing, 5)
                .transition(.move(edge: .leading).combined(with: .opacity))
            }

            VStack(spacing: 6) {
                if !showDetail {
                    HStack {
                        var count: Int { habit.weekDays?.count ?? 0 }

                        Text(count == 7 ? "Everyday" : "\(count) times a week")
                            .font(.callout)
                            .foregroundColor(.white)
                            .opacity(0.7)

                        Image(systemName: "bell.badge.fill")
                            .foregroundColor((habit.color ?? "Card-1").toColor())
                            .opacity(habit.isReminderOn ? 1 : 0)

                        Spacer()
                    }
                    .animation(.spring, value: showDetail)
                }

                Text(habit.title ?? "Default Title")
                    .font(.title2)
                    .bold()
                    .lineLimit(nil)
                    .foregroundColor(.white)
                    .hLeading()
                    .animation(.spring, value: showDetail)

                VStack {
                    if let description = habit.habitDescription, description != "", showDetail {
                        Text(description)
                            .font(.callout)
                            .foregroundColor(.gray)
                            .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
                            .lineLimit(nil)
                            .hLeading()
                    }
                }
                .animation(.spring, value: showDetail)

                if showDetail {
                    HStack(spacing: 0) {
                        ForEach(activePlot.indices, id: \.self) { index in
                            let item = activePlot[index]

                            let status = activeWeekDays.contains { day in
                                day == item.0
                            }

                            VStack(spacing: 6) {
                                Text(symbols[item.index].prefix(3))
                                    .font(.caption)

                                Text(getDate(date: item.date))
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)

                                Circle()
                                    .fill(.white)
                                    .frame(width: 8, height: 8)
                                    .opacity(status ? 1 : 0)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(habit.color?.toColor() ?? "Card-1".toColor())
                                    .opacity(status ? 1 : 0)
                            }
                        }
                    }
                    .padding(.top, 15)
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
            .background {
                Color.black
                    .opacity(0.85)
                    .cornerRadius(showDetail ? 15 : 25)
            }
            .onTapGesture {
                withAnimation(.smooth(extraBounce: 0.5)) {
                    showDetail.toggle()
                }
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
