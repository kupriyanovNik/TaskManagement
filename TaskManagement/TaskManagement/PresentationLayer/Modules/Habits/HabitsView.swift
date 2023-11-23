//
//  HabitsView.swift
//

import SwiftUI

struct HabitsView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var habitsViewModel: HabitsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private var strings = Localizable.Habits.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                if coreDataViewModel.allHabits.isEmpty {
                    NotFoundView(
                        title: strings.noHabits,
                        description: strings.noHabitsDescription,
                        accentColor: themeManager.selectedTheme.accentColor
                    )
                } else {
                    ForEach(coreDataViewModel.allHabits, id: \.habitID) { habit in
                        if #available(iOS 17, *), settingsViewModel.shouldShowScrollAnimation {
                            HabitCardView(
                                habitsViewModel: habitsViewModel,
                                coreDataViewModel: coreDataViewModel,
                                habit: habit
                            ) { habit in
                                habitsViewModel.editHabit = habit
                                navigationViewModel.showHabitAddingView.toggle()
                            }
                            .scrollTransition(.animated(.bouncy)) { effect, phase in
                                effect
                                    .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                    .opacity(phase.isIdentity ? 1 : 0.8)
                                    .blur(radius: phase.isIdentity ? 0 : 2)
                                    .brightness(phase.isIdentity ? 0 : 0.3)
                            }
                        } else {
                            HabitCardView(
                                habitsViewModel: habitsViewModel,
                                coreDataViewModel: coreDataViewModel,
                                habit: habit
                            ) { habit in
                                habitsViewModel.editHabit = habit
                                navigationViewModel.showHabitAddingView.toggle()
                            }
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

                    if habitsViewModel.showGreetings {
                        Text("!")
                            .foregroundColor(.gray)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }

                Text(strings.title)
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(themeManager.selectedTheme.pageTitleColor)
            }

            Spacer()

            if !coreDataViewModel.allHabits.isEmpty {
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
    HabitsView()
        .environmentObject(HabitsViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(NavigationViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(ThemeManager())
}
