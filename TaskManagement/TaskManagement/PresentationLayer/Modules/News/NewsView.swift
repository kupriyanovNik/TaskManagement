//
//  NewsView.swift
//

import SwiftUI
import Kingfisher

struct NewsView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties

    private var systemImages = ImageNames.System.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                ForEach(networkManager.news, id: \.id) { new in
                    if #available(iOS 17, *), settingsViewModel.shouldShowScrollAnimation {
                        spaceNewCard(new: new)
                            .scrollTransition(.animated(.bouncy)) { effect, phase in
                                effect
                                    .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                    .opacity(phase.isIdentity ? 1 : 0.8)
                                    .blur(radius: phase.isIdentity ? 0 : 2)
                                    .brightness(phase.isIdentity ? 0 : 0.3)
                            }
                    } else {
                        spaceNewCard(new: new)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .makeCustomNavBar {
            headerView()
        }
    }

    // MARK: - View Builders

    @ViewBuilder func spaceNewCard(new: SpaceNewsModel) -> some View {
        VStack(alignment: .leading) {
            Text(new.newsSite)
                .bold()
                .font(.title2)
                .foregroundColor(themeManager.selectedTheme.accentColor)

            KFImage
                .url(URL(string: new.imageUrl))
                .fade(duration: 0.2)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Text(new.title)
                .font(.headline)
                .padding(8)

            Text(new.summary)
                .lineLimit(nil)
                .font(.body)
                .padding(8)

        }
        .padding()
        .background {
            themeManager.selectedTheme.accentColor
                .opacity(0.1)
                .cornerRadius(10)
        }
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

            Text("News Feed")
                .bold()
                .font(.largeTitle)
                .foregroundStyle(themeManager.selectedTheme.pageTitleColor)

            Spacer()

            Button {
                networkManager.getNews()
            } label: {
                HStack(spacing: 3) {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                    Text("Reload")
                }
                .foregroundColor(.black)
                .font(.caption)
                .padding(5)
                .background {
                    themeManager.selectedTheme.accentColor
                        .opacity(0.2)
                        .cornerRadius(10)
                }
            }
            .buttonStyle(HeaderButtonStyle())
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    NewsView()
        .environmentObject(SettingsViewModel())
        .environmentObject(NetworkManager())
        .environmentObject(ThemeManager())
}
