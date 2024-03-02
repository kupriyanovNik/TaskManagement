//
//  InformationView.swift
//

import SwiftUI

struct InformationView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var informationViewModel: InformationViewModel
    @ObservedObject var themeManager: ThemeManager

    // MARK: - Private Properties

    private let strings = Localizable.Information.self
    private let systemImages = ImageConstants.System.self
    private let bundle = Bundle.main

    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    private var appInformationRow: some View {
        VStack {
            Text(bundle.displayName)
                .font(.headline)
                .bold()

            Text("Версия \(bundle.appVersionLong) Сборка \(bundle.appBuild)")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray)
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
                withAnimation {
                    informationViewModel.showInformation.toggle()
                }
            }
        }
    }

    private var createdByRow: some View {
        VStack {
            Group {
                if #available(iOS 16, *) {
                    Text(
                        informationViewModel.showDeveloper ?
                            "Created by Nikita Kupriyanov🧑‍💻" :
                            "Designed by Anfisa Oparina👧🏻"
                    )
                    .bold()
                    .contentTransition(.numericText())
                } else {
                    if informationViewModel.showDeveloper {
                        Text("Created by Nikita Kupriyanov🧑‍💻")
                            .bold()
                            .transition(.move(edge: .top).combined(with: .opacity))
                    } else {
                        Text("Designed by Anfisa Oparina👧🏻")
                            .bold()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .font(.headline)

            Text("❤️SwiftUI - less code❤️")
                .font(.caption)
                .foregroundStyle(.gray)
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
                withAnimation {
                    informationViewModel.showInformation.toggle()
                }
            }
        }
        .animation(.default, value: informationViewModel.showDeveloper)
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading) {
            openInTelegramCard()
            openInGitHubCard()
            openInAppStoreCard()

            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
            headerView()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                if informationViewModel.showInformation {
                    createdByRow
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    appInformationRow
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .onReceive(timer) { _ in
            informationViewModel.showDeveloper.toggle()
        }
        .onDisappear {
            withAnimation {
                informationViewModel.showInformation = false 
            }
        }
    }

    // MARK: - ViewBuilders

    @ViewBuilder func openInTelegramCard() -> some View {
        Button {
            if let url = URL(string: "https://t.me/+aiEd-3N-sHlmMWYy"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack {
                Text("Чат в Telegram")
                    .fontWeight(.semibold)
                    .font(.title2)

                Spacer()

                Image(systemName: systemImages.paperplane)
                    .font(.title2)
            }
            .padding()
            .background {
                themeManager.selectedTheme.accentColor
                    .opacity(0.2)
                    .cornerRadius(10)
            }
        }
        .buttonStyle(HeaderButtonStyle(pressedScale: 1.03))
    }

    @ViewBuilder func openInGitHubCard() -> some View {
        Button {
            if let url = URL(string: "https://github.com/kupriyanovNik/TaskManagement"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack {
                Text("Мы на GitHub")
                    .fontWeight(.semibold)
                    .font(.title2)

                Spacer()

                Image(systemName: systemImages.network)
                    .font(.title2)
            }
            .padding()
            .background {
                themeManager.selectedTheme.accentColor
                    .opacity(0.2)
                    .cornerRadius(10)
            }
        }
        .buttonStyle(HeaderButtonStyle(pressedScale: 1.03))
    }

    @ViewBuilder func openInAppStoreCard() -> some View {
        Button {
            // TODO: - open in AppStore
        } label: {
            HStack {
                Text("Мы в AppStore")
                    .fontWeight(.semibold)
                    .font(.title2)

                Spacer()

                Image(systemName: systemImages.nosign)
                    .font(.title2)
            }
            .padding()
            .background {
                themeManager.selectedTheme.accentColor
                    .opacity(0.2)
                    .cornerRadius(10)
            }
        }
        .buttonStyle(HeaderButtonStyle(pressedScale: 1.03))
    }

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
    InformationView(
        informationViewModel: .init(),
        themeManager: .init()
    )
}
