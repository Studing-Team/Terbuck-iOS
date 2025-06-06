//
//  Endpoint.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

// HTTP 메서드 열거형
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum RequestBodyType {
    case json           // raw JSON
    case formData      // multipart/form-data
}

// Endpoint 프로토콜
public protocol EndpointProtocol {
    var basePath: BasePath { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HeaderType? { get }
    var requestBodyType: RequestBodyType { get }
    var parameters: [URLQueryItem]? { get }
    var body: Encodable? { get }
    // multipart 전용 (필요한 경우만 사용)
    var multipartFormData: [String: Any]? { get }
}

extension EndpointProtocol {
    var baseURL: URL {
        guard let baseURL = URL(string: Config.baseURL) else {
            fatalError("🍞⛔️ Base URL이 없어요! ⛔️🍞")
        }
        return baseURL
    }
}

public enum BasePath: String {
    case store = "shops"
    case auth = "auth"
    case partnership = "partnership"
    case member = "member"
}

// Endpoint 구조체 구현
struct Endpoint: EndpointProtocol {
    let basePath: BasePath
    let path: String
    let method: HTTPMethod
    let requestBodyType: RequestBodyType
    let parameters: [URLQueryItem]?
    let headers: HeaderType?
    let body: Encodable?
    let multipartFormData: [String: Any]?
    
    init(basePath: BasePath,
         path: String,
         method: HTTPMethod = .get,
         requestBodyType: RequestBodyType,
         parameters: [URLQueryItem]? = nil,
         headers: HeaderType? = nil,
         body: Encodable? = nil,
         multipartFormData: [String: Any]?) {
        self.basePath = basePath
        self.path = path
        self.method = method
        self.requestBodyType = requestBodyType
        self.parameters = parameters
        self.headers = headers
        self.body = body
        self.multipartFormData = multipartFormData
    }
}
