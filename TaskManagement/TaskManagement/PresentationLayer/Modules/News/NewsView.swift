//
//  NewsView.swift
//

import SwiftUI

struct NewsView: View {

    // MARK: - Property Wrappers

    @Environment(\.dismiss) var dismiss

    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var networkManager: NetworkManager
    @ObservedObject var coreDataManager: CoreDataManager
    @ObservedObject var themeManager: ThemeManager

    @State private var showHeaderTap: Bool = false

    // MARK: - Private Properties

    private let systemImages = ImageConstants.System.self
    private let strings = Localizable.News.self

    // MARK: - Body

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading) {
                if networkManager.companyTasks.isEmpty {
                    ProgressView()
                        .tint(themeManager.selectedTheme.accentColor)
                        .hCenter()
                } else {
                    ForEach(networkManager.companyTasks, id: \.id) { task in
                        companyTaskCard(task)
                            .modifier(ScrollTransitionModifier(condition: settingsViewModel.shouldShowScrollAnimation))
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .animation(.bouncy, value: networkManager.companyTasks)
        .makeCustomNavBar {
            headerView()
        }
        .onAppear {
            networkManager.getNews(isInitial: false)
        }
    }

    // MARK: - View Builders

    @ViewBuilder func companyTaskCard(_ task: NetworkDataModel) -> some View {
        let deadlineText = task.deadline.formatted(date: .numeric, time: .shortened)

        VStack(alignment: .leading) {
            Text(task.title)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.leading)

            if let url = task.imageUrl {
                CachedAsyncImage(imageUrlString: url) { image in
                    Image(uiImage: image)
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .hCenter()
                .padding()
            }

            Text(task.description)
                .multilineTextAlignment(.leading)
                .font(.headline)

            if task.isSaveable {
                Button {
                    coreDataManager.addTask(
                        id: task.id ?? UUID().uuidString,
                        title: task.title,
                        description: task.description,
                        date: task.deadline,
                        category: .important,
                        shouldNotificate: true
                    )
                } label: {
                    Text("Сохранить (\(deadlineText))")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.primary)
                        .padding(.top)
                }
            }
        }
        .hLeading()
        .padding()
        .background {
            themeManager.selectedTheme.accentColor
                .opacity(0.1)
                .cornerRadius(10)
        }

    }

    @ViewBuilder func headerView() -> some View {
        HStack {
            if !showHeaderTap {
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
                        ImpactManager.generateFeedback()

                        networkManager.getNews(isInitial: false)
                    }
                } onPressingChanged: { isPressed in
                    withAnimation {
                        showHeaderTap = isPressed
                    }
                }

            Spacer()
        }
        .foregroundStyle(.linearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom))
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    NewsView(
        settingsViewModel: .init(),
        networkManager: .init(),
        coreDataManager: .init(),
        themeManager: .init()
    )
}
