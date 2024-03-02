//
//  DataProvider.swift
//

import Foundation

final class DataProvider {

    // MARK: - Static Properties

    static var sessionDispatcher: SessionDispatcher = .init()
    
    static func fetchData<R: Request>(_ request: R) async throws -> R.ReturnType {
        let urlString = NetworkConstants.urlString.rawValue
        guard let urlRequest = request.asURLRequest(urlString) else {
            throw APIError.badRequest
        }
        
        typealias RequestType = R.ReturnType
        let returnType: RequestType = try await sessionDispatcher.dispatch(request: urlRequest)
        
        return returnType
    }
}
