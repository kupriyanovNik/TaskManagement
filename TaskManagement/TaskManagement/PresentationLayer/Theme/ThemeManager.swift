//
//  ThemeManager.swift
//

import SwiftUI

class ThemeManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published var selectedTheme: Theme = Theme1()
    
    @AppStorage(Constants.UserDefaultsKeys.selectedTheme) var selectedThemeIndex: Int = 0 {
        willSet {
            objectWillChange.send()
        }
        didSet {
            updateTheme()
        }
    }

    // MARK: - Inits

    init() {
        updateTheme()
    }

    // MARK: - Private Functions 

    private func updateTheme() {
        selectedTheme = DataSource.getTheme(themeIndex: selectedThemeIndex)
    }
}
