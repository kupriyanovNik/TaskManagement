//
//  SessionDispatch.swift
//

import Foundation

final class SessionDispatcher {

    // MARK: - Internal Properties

    let urlSession: URLSession = .shared

    // MARK: - Internal Functions

    func dispatch<ReturnType: Codable>(request: URLRequest) async throws -> ReturnType {
        let method = request.httpMethod?.uppercased() ?? ""
        print("[\(method)] \(request.url!)")
        
        let (data, responce) = try await urlSession.data(for: request)
        
        if let httpResponce = responce as? HTTPURLResponse,
           !(200...299).contains(httpResponce.statusCode) {
            throw self.httpError(httpResponce.statusCode)
        }
        
        let fetchedData = try JSONDecoder().decode(ReturnType.self, from: data)
        
        return fetchedData
    }
    
    // MARK: - Private Functions

    private func httpError(_ statusCode: Int) -> APIError {
        switch statusCode {
            case 404: .notFound
            case 401: .unauthorized
            case 403: .forbidden
            case 500: .serverError
            case 501...509: .error5xx(statusCode)
            default: .unknownError
        }
    }
    
    private func findDecodingError(for error: DecodingError) {
        switch error {
            case .typeMismatch(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .valueNotFound(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .keyNotFound(let key, let value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case .dataCorrupted(let key):
                print("error \(key), and ERROR: \(error.localizedDescription)")
            default:
                print("ERROR: \(error.localizedDescription)")
        }
    }
}
