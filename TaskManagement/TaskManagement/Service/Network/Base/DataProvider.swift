//
//  DataProvider.swift
//

import Foundation

final class DataProvider {
    private static var sessionDispatcher: SessionDispatcher = .init()
    
    static func fetchData<R: Request>(_ request: R) async throws -> R.ReturnType {
        guard let urlRequest = request.asURLRequest("https://api.spaceflightnewsapi.net") else {
            throw APIError.badRequest
        }
        
        typealias RequestType = R.ReturnType
        let returnType: RequestType = try await sessionDispatcher.dispatch(request: urlRequest)
        return returnType
    }
}
