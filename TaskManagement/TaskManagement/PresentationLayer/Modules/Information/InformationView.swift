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

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("Версия: \(Bundle.main.appVersionLong)")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
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

    // MARK: - ViewBuilders

    @ViewBuilder func headerView() -> some View {
        
    }

}

// MARK: - Preview

#Preview {
    InformationView()
        .environmentObject(ThemeManager())
}
