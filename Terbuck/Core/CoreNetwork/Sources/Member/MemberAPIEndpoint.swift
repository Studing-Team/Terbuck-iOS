//
//  MemberAPIEndpoint.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public enum MemberAPIEndpoint {
    case postSignin(SigninRequestDTO)
    case deleteMemeber
    case patchUniversity(ChangeUniversityRequestDTO)
    case getStudentId
    case putRegisterStudentId(RegisterStudentIDRequestDTO)
    case deleteStudentId
}

extension MemberAPIEndpoint: EndpointProtocol {
    public var basePath: BasePath {
        return .member
    }
    
    public var path: String {
        switch self {
        case .postSignin:
            return basePath.rawValue + "/signin"
        case .deleteMemeber:
            return basePath.rawValue
        case .patchUniversity:
            return basePath.rawValue + "/univ"
        case .getStudentId, .putRegisterStudentId, .deleteStudentId:
            return basePath.rawValue + "/studentID"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .postSignin:
            return .post
        case .patchUniversity:
            return .patch
        case .getStudentId:
            return .get
        case .putRegisterStudentId:
            return .put
        case .deleteMemeber, .deleteStudentId:
            return .delete
        }
    }
    
    public var headers: HeaderType? {
        return .accessTokenHeader
    }
    
    public var requestBodyType: RequestBodyType {
        switch self {
        case .putRegisterStudentId:
            return .formData
        default:
            return .json
        }
    }
    
    public var parameters: [URLQueryItem]? {
        return nil
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .postSignin(let dto):
            return dto
        case .patchUniversity(let dto):
            return dto
        default:
            return nil
        }
    }
    
    public var multipartFormData: [String : Any]? {
        switch self {
        case .putRegisterStudentId(let dto):
            return [
                "image": dto.image,
                "name": dto.name,
                "studentNumber": dto.studentNumber
            ]
        default:
            return nil
        }
    }
}
