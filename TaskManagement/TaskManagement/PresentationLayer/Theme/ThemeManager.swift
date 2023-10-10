//
//  ThemeManager.swift
//

import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("Theme.selectedThemeIndex") var selectedThemeIndex: Int = 0 {
        willSet {
            objectWillChange.send()
        }
        didSet {
            updateTheme()
        }
    }

    init() {
        updateTheme()
    }

    @Published var selectedTheme: Theme = Theme1()

    private func updateTheme() {
        selectedTheme = DataSource.getTheme(themeIndex: selectedThemeIndex)
    }
}
