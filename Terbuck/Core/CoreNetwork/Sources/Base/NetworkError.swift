//
//  NetworkError.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case invalidParameters
    case requestFailed(description: String)
    case noData
    case decodingFailed(Error)
    case unAuthorizedError
    case httpResponseNotOK(statusCode: Int)
    case encodingFailed
    case unknown
    case tokenRefreshFailed(Error)
    case maxRetryExceeded
    case tokenExpiration
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "🛠️ 유효하지 않은 URL입니다. 🛠️"
        case .invalidParameters:
            return "🛠️ 유효하지 않은 매개변수입니다. 🛠️"
        case .requestFailed(let description):
            return "네트워크 요청 실패: \(description)"
        case .noData:
            return "서버에서 데이터를 받지 못했습니다."
        case .decodingFailed(let error):
            return "⚙️ JSON Decoding 에러입니다. :\(error.localizedDescription) ⚙️"
        case .unAuthorizedError:
            return "⛏️ 접근 권한이 없습니다 (토큰 만료) ⛏️"
        case .httpResponseNotOK(let statusCode):
            return "HTTP 요청 실패: 상태 코드 \(statusCode)"
        case .encodingFailed:
            return "데이터 인코딩에 실패했습니다."
        case .unknown:
            return "📁 알 수 없는 오류가 발생했습니다. 📁"
        case .tokenRefreshFailed(_):
            return "토큰 재발급에 대해 오류가 발생했습니다."
        case .maxRetryExceeded:
            return "재시도 할 수 있는 횟수가 초과되었습니다."
        case .tokenExpiration:
            return "유효하지 않은 토큰입니다."
        }
    }
}
