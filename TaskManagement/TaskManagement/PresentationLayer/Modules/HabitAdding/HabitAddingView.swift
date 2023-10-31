//
//  HabitAddingView.swift
//

import SwiftUI

struct HabitAddingView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var habitAddingViewModel: HabitAddingViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties

    private var systemImages = ImageNames.System.self
    private var strings = Localizable.HabitAdding.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {

        }
        .makeCustomNavBar {
            headerView()
        }
    }

    // MARK: - View Builders

    @ViewBuilder func headerView() -> some View {
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
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding([.horizontal, .top])
    }

}

// MARK: - Preview

#Preview {
    HabitAddingView()
        .environmentObject(HabitAddingViewModel())
        .environmentObject(ThemeManager())
}
