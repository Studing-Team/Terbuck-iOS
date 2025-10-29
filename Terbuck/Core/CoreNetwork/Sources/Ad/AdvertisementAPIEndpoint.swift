//
//  AdvertisementAPIEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 10/25/25.
//

import Foundation

public enum AdvertisementAPIEndpoint {
    /// 홈화면의 광고 배너를 조회
    case getAdvertisementBannerInfoList
}

extension AdvertisementAPIEndpoint: EndpointProtocol {
    public var basePath: BasePath {
        return .ad
    }
    
    public var path: String {
        switch self {
        case .getAdvertisementBannerInfoList:
            return basePath.rawValue + "/banners"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getAdvertisementBannerInfoList:
            return .get
        }
    }
    
    public var headers: HeaderType? {
        return .accessTokenHeader
    }
    
    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    public var parameters: [URLQueryItem]? {
        return nil
    }
    
    public var body: (any Encodable)? {
        return nil
    }
    
    public var multipartFormData: [String : Any]? {
        return nil
    }
}
