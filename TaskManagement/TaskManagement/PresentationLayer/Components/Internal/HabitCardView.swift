//
//  HabitCardView.swift
//

import SwiftUI

struct HabitCardView: View {

    // MARK: - Embedded

    private enum CardState {
        case basic
        case description
        case extended
    }

    // MARK: - Property Wrappers

    @ObservedObject var habitsViewModel: HabitsViewModel
    @ObservedObject var coreDataViewModel: CoreDataViewModel

    @State private var cardState: CardState = .basic

    // MARK: - Internal Properties

    let habit: HabitModel

    var editAction: ((HabitModel) -> ())? = nil

    // MARK: - Private Properties

    private let systemImages = ImageNames.System.self
    private let strings = Localizable.HabitCard.self
    private let calendar = Calendar.current

    // MARK: - Body

    var body: some View {
        HStack {
            if habitsViewModel.isEditing {
                habitCardEditView()
            }

            habitCardView()
                .padding(.vertical)
                .padding(.horizontal)
                .background {
                    Color.black
                        .opacity(cardState != .basic ? 0.95 : 0.85)
                        .cornerRadius(cardState != .basic ? 15 : 25)
                }
                .onTapGesture {
                    habitCardTapAction()
                }
                .scaleEffect(cardState == .extended ? 1.02 : 1)
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func habitCardView() -> some View {
        VStack(spacing: 6) {
            if cardState == .basic {
                habitCardDayCounter()
            }

            Text(habit.title ?? "Default Title")
                .font(.title2)
                .bold()
                .lineLimit(nil)
                .foregroundColor(.white)
                .hLeading()
                .animation(.spring, value: cardState)

            VStack {
                if let description = habit.habitDescription,
                   description != "",
                    cardState == .description || cardState == .extended {
                    Text(description)
                        .font(.callout)
                        .foregroundColor(.gray)
                        .transition(.move(edge: .top).combined(with: .opacity).combined(with: .scale))
                        .lineLimit(nil)
                        .hLeading()
                }
            }
            .animation(.spring, value: cardState)

            if cardState == .extended {
                habitCardCalendarView()
            }
        }
    }

    @ViewBuilder func habitCardDayCounter() -> some View {
        var count: Int { habit.weekDays?.count ?? 0 }

        HStack {
            Text(count == 7 ? strings.everyday : "\(count) \(strings.timeAweek)")
                .font(.callout)
                .foregroundColor(.white)
                .opacity(0.7)

            Image(systemName: systemImages.bellBadge)
                .foregroundColor((habit.color ?? "Card-1").toColor())
                .opacity(habit.isReminderOn ? 1 : 0)

            Spacer()
        }
        .animation(.spring, value: cardState)
    }

    @ViewBuilder func habitCardEditView() -> some View {
        VStack(spacing: 10) {
            Button {
                editAction?(habit)
            } label: {
                Image(systemName: systemImages.pencilCircleFill)
                    .font(.title2)
                    .foregroundColor(.primary)
            }

            Button {
                withAnimation {
                    coreDataViewModel.removeHabit(habit: habit) { _, ids in
                        coreDataViewModel.fetchAllHabits()
                        NotificationManager.shared.removeNotifications(with: ids)
                    }
                }
            } label: {
                Image(systemName: systemImages.minusCircleFill)
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding(.trailing, 5)
        .transition(.move(edge: .leading).combined(with: .opacity))
    }

    @ViewBuilder func habitCardCalendarView() -> some View {
        let currentWeek = calendar.dateInterval(of: .weekOfMonth, for: .now)
        let startDate = currentWeek?.start ?? .now
        let symbols = calendar.weekdaySymbols

        let activeWeekDays = habit.weekDays ?? []

        let activePlot = symbols.indices
            .compactMap { index -> (index: Int, date: Date) in
                let currentDate = calendar.date(byAdding: .day, value: index, to: startDate)
                return (index, currentDate ?? .now)
            }

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
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
                .background {
                    Capsule()
                        .fill(habit.color?.toColor() ?? "Card-1".toColor())
                        .opacity(status ? 1 : 0)
                }
                .padding(5)
            }
        }
        .padding(.top, 15)
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    // MARK: - Private Functions

    private func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormats.forDateNumber

        return formatter.string(from: date)
    }

    private func habitCardTapAction() {
        withAnimation(.easeOut) {
            if cardState == .basic {
                if let description = habit.habitDescription,
                   description != "" { cardState = .description }
                else { cardState = .extended }
            }
            else if cardState == .description { cardState = .extended }
            else if cardState == .extended { cardState = .basic }
        }
    }

}
