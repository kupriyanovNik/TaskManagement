//
//  HabitsView.swift
//

import SwiftUI

struct HabitsView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var habitsViewModel: HabitsViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(coreDataViewModel.allHabits, id: \.habitID) { habit in
                    Text(habit.title ?? "Default Title")
                }
            }
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
                    Text("Get Better")
                        .foregroundColor(.gray)

                    if habitsViewModel.showGreetings {
                        Text("✅")
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }

                Text("Habits")
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(themeManager.selectedTheme.pageTitleColor)

            }

            Spacer()
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }

}

// MARK: - Preview

#Preview {
    HabitsView()
        .environmentObject(HabitsViewModel())
        .environmentObject(CoreDataViewModel())
        .environmentObject(ThemeManager())
}
