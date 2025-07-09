//
//  AuthAPIEndpoint.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation
import CoreKeyChain

public enum AuthAPIEndpoint {
    case postAuthKakao(KakaoLoginRequestDTO)
    case postAuthApple(AppleLoginRequestDTO)
    case postReissue
    case postNotificationToken(NotificationTokenRequestDTO)
}

extension AuthAPIEndpoint: EndpointProtocol {
    public var basePath: BasePath {
        return .auth
    }
    
    public var path: String {
        switch self {
        case .postAuthKakao:
            return basePath.rawValue + "/kakao"
        case .postAuthApple:
            return basePath.rawValue + "/apple"
        case .postReissue:
            return basePath.rawValue + "/reissue"
        case .postNotificationToken:
            return "fcm/token"
        }
    }
    
    public var method: HTTPMethod {
        return .post
    }
    
    public var headers: HeaderType? {
        switch self {
        case .postNotificationToken:
            return .accessTokenHeader
        default:
            return .defaultHeader
        }
    }
    
    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    public var parameters: [URLQueryItem]? {
        return nil
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .postAuthKakao(let dto):
            return dto
        case .postAuthApple(let dto):
            return dto
        case .postReissue:
            if let token = KeychainManager.shared.load(key: .refreshToken) {
                return ReissueRequestDTO(refreshToken: token)
            }
            
            return nil
        case .postNotificationToken(let dto):
            return dto
        }
    }
    
    public var multipartFormData: [String : Any]? {
        return nil
    }
}
