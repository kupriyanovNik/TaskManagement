//
//  RequestImplimentation.swift
//

import Foundation

final class Requests {
    
    static let shared = Requests()

    struct GetNews: Request {
        typealias ReturnType = [SpaceNewsModel]
        let path: String = "/v3/articles"
        var queryParam: QueryParams? = nil
    }

}
