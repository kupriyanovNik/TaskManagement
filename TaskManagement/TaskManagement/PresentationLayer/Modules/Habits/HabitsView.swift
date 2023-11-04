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
                            HabitCardView(
                                habitsViewModel: habitsViewModel,
                                coreDataViewModel: coreDataViewModel,
                                habit: habit
                            )
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
                            )
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
