//
//  StoreAPIEndpoint.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public enum StoreAPIEndpoint {
    case getHomeStore(SearchStoreRequestDTO)
    case getMapStore(SearchStoreMapRequestDTO)
    case getDetailStore(SearchDetailStoreIdRequestDTO)
}

extension StoreAPIEndpoint: EndpointProtocol {
    public var basePath: BasePath {
        return .store
    }
    
    public var path: String {
        switch self {
        case .getHomeStore:
            return basePath.rawValue + "/home"
        case .getMapStore:
            return basePath.rawValue + "/map"
        case .getDetailStore(let dto):
            return basePath.rawValue + "/\(dto.shop_Id)"
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var headers: HeaderType? {
        return .accessTokenHeader
    }
    
    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    public var parameters: [URLQueryItem]? {
        switch self {
        case .getHomeStore(let dto):
            return dto.toQueryItems()
        case .getMapStore(let dto):
            return dto.toQueryItems()
        case .getDetailStore(let dto):
            return dto.toQueryItems()
        }
    }
    
    public var body: (any Encodable)? {
        switch self {
        default:
            return nil
        }
    }
    
    public var multipartFormData: [String : Any]? {
        return nil
    }
}
