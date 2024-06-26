//
//  HabitsView.swift
//

import SwiftUI

struct HabitsView: View {

    // MARK: - Property Wrappers

    @ObservedObject var habitsViewModel: HabitsViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var navigationManager: NavigationManager
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private let strings = Localizable.Habits.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach(coreDataManager.allHabits, id: \.habitID) { habit in
                    HabitCardView(
                        habitsViewModel: habitsViewModel,
                        coreDataManager: coreDataManager,
                        habit: habit
                    ) { habit in
                        habitsViewModel.editHabit = habit
                        navigationManager.showHabitAddingView.toggle()
                    }
                    .modifier(ScrollTransitionModifier(condition: settingsViewModel.shouldShowScrollAnimation))
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
        .overlay {
            if coreDataManager.allHabits.isEmpty {
                NotFoundView(
                    title: strings.noHabits,
                    description: strings.noHabitsDescription,
                    accentColor: themeManager.selectedTheme.accentColor
                )
            }
        }
    }

    // MARK: - View Builders

    @ViewBuilder func headerView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 0) {
                    if habitsViewModel.showGreetings {
                        Text("✅")
                            .transition(.move(edge: .leading).combined(with: .opacity))
                    }

                    Text(strings.subtitle)
                        .foregroundColor(.gray)
                }

                Text(strings.title)
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(themeManager.selectedTheme.pageTitleColor)
            }

            Spacer()

            if !coreDataManager.allHabits.isEmpty {
                Button(habitsViewModel.editText) {
                    withAnimation {
                        habitsViewModel.isEditing.toggle()
                    }
                }
                .buttonStyle(HeaderButtonStyle())
                .foregroundColor(themeManager.selectedTheme.pageTitleColor)
            }
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    HabitsView(
        habitsViewModel: .init(),
        settingsViewModel: .init(),
        navigationManager: .init(),
        coreDataManager: .init(),
        themeManager: .init()
    )
}
