//
//  ThemeManager.swift
//

import SwiftUI

class ThemeManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published var selectedTheme: ThemeProtocol = Theme1()

    @AppStorage(
        UserDefaultsKeys.selectedThemeIndex.rawValue
    ) var selectedThemeIndex: Int = 0 {
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
        selectedTheme = ThemeDataSource.getTheme(themeIndex: selectedThemeIndex)
    }
}
