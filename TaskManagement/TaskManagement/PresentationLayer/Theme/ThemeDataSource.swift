//
// ThemeDataSource.swift
//

import SwiftUI

enum ThemeDataSource {

    // MARK: - Static Properties

    static let themes: [ThemeProtocol] = [
        Theme1(),
        Theme2(),
        Theme3(),
        Theme4()
    ]

    static var themesCount: Int {
        Self.themes.count
    }

    // MARK: - Static Functions

    static func getTheme(themeIndex: Int) -> ThemeProtocol {
        Self.themes[themeIndex]
    }
}
