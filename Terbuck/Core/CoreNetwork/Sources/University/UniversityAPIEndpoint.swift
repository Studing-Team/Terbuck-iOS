//
//  UniversityAPIEndpoint.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 9/2/25.
//

import Foundation

public enum UniversityAPIEndpoint {
    case getUniversityInfoList
    /// 우리 학교의 제휴 업체 '공개 상태'를 조회
    case getPartnershipDisclosureStatus(MyUniversityRequestDTO)
    /// 제휴 업체 '공개 요청'을 생성
    case postPartnershipDisclosureRequest(MyUniversityRequestDTO)
    /// 내가 보낸 '공개 요청'의 처리 '상태'를 조회
    case getDisclosureRequestStatus(MyUniversityRequestDTO)
    /// 대학별 '단과대' 조회
    case getCollegesInfoList(MyUniversityRequestDTO)
}

extension UniversityAPIEndpoint: EndpointProtocol {
    public var basePath: BasePath {
        return .university
    }
    
    public var path: String {
        switch self {
        case .getUniversityInfoList:
            return basePath.rawValue + "/by-region"
        case .getPartnershipDisclosureStatus:
            return basePath.rawValue + "/is-registered"
        case .postPartnershipDisclosureRequest, .getDisclosureRequestStatus:
            return basePath.rawValue + "/open"
        case .getCollegesInfoList:
            return basePath.rawValue + "/colleges"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getUniversityInfoList, .getPartnershipDisclosureStatus, .getDisclosureRequestStatus, .getCollegesInfoList:
            return .get
        case .postPartnershipDisclosureRequest:
            return .post
        }
    }
    
    public var headers: HeaderType? {
        return .accessTokenHeader
    }
    
    public var requestBodyType: RequestBodyType {
        return .json
    }
    
    public var parameters: [URLQueryItem]? {
        switch self {
        case .getDisclosureRequestStatus(let dto):
            return dto.toQueryItems()
        case .getPartnershipDisclosureStatus(let dto):
            return dto.toQueryItems()
        case .postPartnershipDisclosureRequest(let dto):
            return dto.toQueryItems()
        case .getCollegesInfoList(let dto):
            return dto.toQueryItems()
        default:
            return nil
        }
    }
    
    public var body: (any Encodable)? {
        return nil
    }
    
    public var multipartFormData: [String : Any]? {
        return nil
    }
}
