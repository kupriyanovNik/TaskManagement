//
//  DataSource.swift
//

import SwiftUI

enum DataSource {

    // MARK: - Static Properties

    static let themes: [Theme] = [
        Theme0(),
        Theme1(),
        Theme2(),
        Theme3(),
        Theme4(),
        Theme5(),
        Theme6(),
        Theme7(),
        Theme8(),
        Theme9()
    ]

    static var themesCount: Int {
        Self.themes.count
    }

    // MARK: - Static Functions

    static func getTheme(themeIndex: Int) -> Theme {
        Self.themes[themeIndex]
    }
}
