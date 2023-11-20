//
//  DataSource.swift
//

import SwiftUI

enum DataSource {

    // MARK: - Static Properties

    static let themes: [Theme] = [
        Theme1(),
        Theme2(),
        Theme3(),
        Theme4()
    ]

    static var themesCount: Int {
        Self.themes.count
    }

    // MARK: - Static Functions

    static func getTheme(themeIndex: Int) -> Theme {
        Self.themes[themeIndex]
    }
}
