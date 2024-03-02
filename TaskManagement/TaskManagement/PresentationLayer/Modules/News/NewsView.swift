//
//  NewsView.swift
//

import SwiftUI
import Kingfisher

struct NewsView: View {

    // MARK: - Property Wrappers

    @EnvironmentObject var newsViewModel: NewsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var themeManager: ThemeManager

    @Environment(\.dismiss) var dismiss

    // MARK: - Private Properties

    private var systemImages = ImageConstants.System.self

    private var strings = Localizable.News.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                if networkManager.news.isEmpty {
                    ProgressView()
                        .tint(themeManager.selectedTheme.accentColor)
                        .hCenter()
                } else {
                    ForEach(networkManager.news, id: \.id) { new in
                        spaceNewCard(new: new)
                            .modifier(ScrollTransitionModifier(condition: $settingsViewModel.shouldShowScrollAnimation))
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
        .onAppear {
            if networkManager.news.isEmpty {
                networkManager.getNews()
            }

            newsViewModel.appearAction()
        }
        .onDisappear {
            newsViewModel.stopTimer()
        }
        .onReceive(newsViewModel.timer) { timer in
            newsViewModel.timerTick()

            if newsViewModel.leastTime < 0 {
                newsViewModel.lastSeenNews = Date().timeIntervalSince1970

                dismiss()
            }
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
        let time = newsViewModel.leastTime

        HStack {
            if !newsViewModel.showHeaderTap {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: systemImages.backArrow)
                        .foregroundColor(.black)
                        .font(.title2)
                }
                .transition(.move(edge: .leading).combined(with: .opacity))
            } else {
                HStack(spacing: 3) {
                    Image(systemName: systemImages.antenna)
                    
                    Text(strings.refresh)
                }
                .foregroundColor(.black)
                .font(.caption)
                .padding(5)
                .background {
                    themeManager.selectedTheme.accentColor
                        .opacity(0.2)
                        .cornerRadius(10)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            Text(strings.newsFeed)
                .bold()
                .font(.largeTitle)
                .foregroundStyle(themeManager.selectedTheme.pageTitleColor)
                .onLongPressGesture(minimumDuration: 1.5, maximumDistance: 50) {
                    withAnimation {
                        ImpactManager.shared.generateFeedback()

                        networkManager.getNews()
                    }
                } onPressingChanged: { isPressed in
                    withAnimation {
                        newsViewModel.showHeaderTap = isPressed
                    }
                }

            Spacer()

            HStack(spacing: 3) {
                Image(systemName: systemImages.lock)
                Text("\(time / 60):\(time % 60)\((time % 60 < 10 && time / 60 != 0)  ? "0" : "")")
            }
            .foregroundColor(.black)
            .font(.caption)
            .padding(5)
            .background {
                themeManager.selectedTheme.accentColor
                    .opacity(0.2)
                    .cornerRadius(10)
            }
            .frame(alignment: .trailing)
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    NewsView()
        .environmentObject(NewsViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(NetworkManager())
        .environmentObject(ThemeManager())
}
