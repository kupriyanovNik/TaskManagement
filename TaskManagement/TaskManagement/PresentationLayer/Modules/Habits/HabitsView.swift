//
//  HabitsView.swift
//

import SwiftUI

struct HabitsView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var habitsViewModel: HabitsViewModel
    @EnvironmentObject var themeManager: ThemeManager

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {

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
                if habitsViewModel.showGreetings {
                    Text("📋✅")
                        .transition(.move(edge: .leading).combined(with: .opacity).combined(with: .scale))
                } else {
                    Text("0")
                        .opacity(0)
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
        .onAppear {
            delay(3) {
                withAnimation(.default) {
                    habitsViewModel.showGreetings = false
                }
            }
        }
    }

}

// MARK: - Preview

#Preview {
    HabitsView()
        .environmentObject(HabitsViewModel())
        .environmentObject(ThemeManager())
}
