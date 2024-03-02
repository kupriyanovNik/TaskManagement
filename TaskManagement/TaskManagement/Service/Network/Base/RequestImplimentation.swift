//
//  RequestImplimentation.swift
//

import Foundation

final class Requests {

    // MARK: - Embedded

    struct GetNews: Request {
        typealias ReturnType = [SpaceNewsModel]
        let path: String = "/v3/articles"
        var queryParam: QueryParams? = nil
    }
}
