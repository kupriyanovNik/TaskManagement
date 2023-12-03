//
//  InformationView.swift
//

import SwiftUI

struct InformationView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var informationViewModel: InformationViewModel
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties

    private let strings = Localizable.Information.self
    private let systemImages = ImageNames.System.self
    private let bundle = Bundle.main

    private var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    private var appInformationRow: some View {
        VStack {
            Text("myHabits")
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
            Spacer()
        }
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
        .environmentObject(InformationViewModel())
        .environmentObject(ThemeManager())
}
