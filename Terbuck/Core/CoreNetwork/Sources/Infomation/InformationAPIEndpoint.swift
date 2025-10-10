//
//  InfomationAPIEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/25/25.
//

import Foundation

public enum InformationAPIEndpoint {
    case getCurrentVersion(CurrentVersionRequestDTO)
    case getCheckUpdateState(CheckUpdateStateRequestDTO)
}

extension InformationAPIEndpoint: EndpointProtocol {
    public var basePath: BasePath {
        return .information
    }
    
    public var path: String {
        switch self {
        case .getCurrentVersion:
            return basePath.rawValue + "/version"
        case .getCheckUpdateState:
            return basePath.rawValue + "/update-check"
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var headers: HeaderType? {
        return nil
    }
    
    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    public var parameters: [URLQueryItem]? {
        switch self {
        case .getCurrentVersion(let dto):
            return dto.toQueryItems()
        case .getCheckUpdateState(let dto):
            return dto.toQueryItems()
        }
    }
    
    public var body: (any Encodable)? {
        return nil
    }
    
    public var multipartFormData: [String : Any]? {
        return nil
    }
}
