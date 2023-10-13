//
//  ThemeManager.swift
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var selectedTheme: Theme = Theme1()
    
    @AppStorage(Constants.UserDefaultsKeys.selectedTheme) var selectedThemeIndex: Int = 0 {
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

    private func updateTheme() {
        selectedTheme = DataSource.getTheme(themeIndex: selectedThemeIndex)
    }
}
