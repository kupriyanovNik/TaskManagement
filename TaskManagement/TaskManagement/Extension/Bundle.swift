//
//  Bundle.swift
//

import Foundation

extension Bundle {

    // MARK: - Internal Properties

    var appName: String {
        getInfo("CFBundleName")
    }

    var displayName: String {
        getInfo("CFBundleDisplayName")
    }

    var language: String { 
        getInfo("CFBundleDevelopmentRegion")
    }

    var identifier: String {
        getInfo("CFBundleIdentifier")
    }

    var copyright: String {
        getInfo("NSHumanReadableCopyright")
            .replacingOccurrences(of: "\\\\n", with: "\n")
    }

    var appBuild: String {
        getInfo("CFBundleVersion")
    }

    var appVersionLong: String {
        getInfo("CFBundleShortVersionString")
    }

    // MARK: - Private Functions 

    private func getInfo(_ str: String) -> String { 
        infoDictionary?[str] as? String ?? "⚠️"
    }
}
