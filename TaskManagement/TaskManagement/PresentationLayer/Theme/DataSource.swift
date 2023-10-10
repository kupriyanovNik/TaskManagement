//
//  DataSource.swift
//

import SwiftUI

enum DataSource {
    static let themes: [Theme] = [
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

    static func getTheme(themeIndex: Int) -> Theme {
        Self.themes[themeIndex]
    }

    static var themesCount: Int {
        Self.themes.count
    }
}
