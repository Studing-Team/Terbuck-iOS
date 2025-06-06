//
//  PartnershipAPIEndpoint.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public enum PartnershipAPIEndpoint {
    case getPartnership(UniversityRequestDTO)
    case getNewPartnership(UniversityRequestDTO)
    case getDetailPartnership(PartnershipIDRequestDTO)
}

extension PartnershipAPIEndpoint: EndpointProtocol {
    public var basePath: BasePath {
        return .partnership
    }
    
    public var path: String {
        switch self {
        case .getPartnership:
            return basePath.rawValue + "/home"
        case .getNewPartnership:
            return basePath.rawValue + "/home_new"
        case .getDetailPartnership(let dto):
            return basePath.rawValue + "/\(dto.partnership_id)"
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
        case .getPartnership(let dto):
            return dto.toQueryItems()
        case .getNewPartnership(let dto):
            return dto.toQueryItems()
        case .getDetailPartnership(let dto):
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
