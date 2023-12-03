//
//  InformationView.swift
//

import SwiftUI

struct InformationView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties

    private let strings = Localizable.Information.self
    private let systemImages = ImageNames.System.self
    private let bundle = Bundle.main

    private var appInformationRow: some View {
        VStack {
            Text("myHabits")
                .font(.title3)
                .bold()

            Text("Версия: \(bundle.appVersionLong) Сборка \(bundle.appBuild)")
                .multilineTextAlignment(.center)
        }
        .hCenter()
        .padding(.horizontal, 24)
        .frame(height: 72)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .white, radius: 100, x: 0, y: 100)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 5)
        .onTapGesture {
            withAnimation {
                // TODO: - Show Information
            }
        }
    }

    private var createdByRow: some View {
        VStack {
            Group {
                Text("Created by Nikita Kupriyanov🧑‍💻")
                Text("Designed by Anfisa Oparina👧🏻")
            }
            .font(.headline)

            Text("❤️SwiftUI - less code❤️")
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.top, 5)
        }
        .hCenter()
        .padding(.horizontal, 24)
        .padding(.vertical)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .white, radius: 100, x: 0, y: 100)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 5)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
            headerView()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                appInformationRow
                createdByRow
            }
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func headerView() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: systemImages.backArrow)
                    .foregroundColor(.black)
                    .font(.title2)
            }

            Text(strings.title)
                .bold()
                .font(.largeTitle)
                .foregroundStyle(themeManager.selectedTheme.pageTitleColor)

            Spacer()
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }

}

// MARK: - Preview

#Preview {
    InformationView()
        .environmentObject(ThemeManager())
}
