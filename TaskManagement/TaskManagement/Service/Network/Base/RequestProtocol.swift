//
//  RequestProtocol.swift
//

import Foundation

typealias HTTPHeader = [HTTPHeaderField.RawValue: String]
typealias QueryParams = [String: Any]

protocol Request {
    var path: String { get }
    var method: APIMethod { get }
    var body: Codable? { get }
    var headers: HTTPHeader? { get }
    var queryParam: QueryParams? { get }
    
    associatedtype ReturnType: Codable
}

extension Request {

    // MARK: - Internal Properties

    var method: APIMethod { .get }
    var body: Codable? { nil }
    var headers: HTTPHeader? { nil }
    var queryParam: QueryParams? { nil }

    // MARK: - Internal Functions

    func asURLRequest(_ baseURL: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        urlComponents.queryItems = addQueryParams(queryParams: queryParam)

        guard let finalURL = urlComponents.url else { return nil }
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = requestFromBody()
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }

    // MARK: - Private Properties

    private func requestFromBody() -> Data? {
        guard let body else { return nil }
        guard let httpBody = try? JSONEncoder().encode(body) else { return nil }
        
        return httpBody
    }
    
    private func addQueryParams(queryParams: QueryParams?) -> [URLQueryItem]? {
        guard let queryParams else { return nil }
        
        return queryParams.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
    }
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case authorization = "Authorization"
    case acceptLanguage = "Accept-Language"
    case userAgent = "User-Agent"
    case apiKey = "x-api-key"
}
