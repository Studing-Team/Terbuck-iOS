//
//  APIClient.swift
//  Core
//
//  Created by ParkJunHyuk on 5/23/25.
//

import Foundation

public struct EmptyResponseDTO: Decodable {}

// URLSessionProtocol 정의
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

// URLSession을 해당 프로토콜 채택
extension URLSession: URLSessionProtocol {}

public class APIClient {
    static let shared = APIClient()
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: EndpointProtocol) async throws -> T {
        var urlRequest: URLRequest
        
        if endpoint.multipartFormData != nil {
            urlRequest = try makeMultipartRequest(from: endpoint)
        } else {
            urlRequest = try makeURLRequest(from: endpoint)
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        return try resultResponse(data: data, response: response)
    }
    
    func requestImageData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}

// MARK: - Private Extension

private extension APIClient {
    func makeURLRequest(from endpoint: EndpointProtocol) throws -> URLRequest {
        
        let baseURL = endpoint.baseURL
        
        let url = baseURL.appendingPathComponent(endpoint.path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        // Query parameters 설정
        if let parameters = endpoint.parameters, !parameters.isEmpty {
            components?.queryItems = parameters
        }

        guard let finalURL = components?.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = endpoint.method.rawValue
        
        // 기본 헤더 설정
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Endpoint Headers 설정
        if let endpointHeader = endpoint.headers {
            for (key, value) in endpointHeader.headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Body 설정
        if let body = endpoint.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(body)
            } catch {
                throw NetworkError.encodingFailed
            }
        }
        
        print("🚀 URL: \(String(describing: urlRequest.url))")
        
        return urlRequest
    }
    
    func makeMultipartRequest(from endpoint: EndpointProtocol) throws -> URLRequest {
        
        let baseURL = endpoint.baseURL
        
        let url = baseURL.appendingPathComponent(endpoint.path)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let lineBreak = "\r\n"
        
        guard let imageData = endpoint.multipartFormData else {
            print("ImageData 없음")
            throw NetworkError.invalidParameters
        }
        
        // 이미지 파일 파트 추가
        for (key, value) in imageData {
            body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
            
            if let imageData = value as? Data {
                let fileName = "image.jpg"
                let mimeType = "image/jpeg"
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"\(lineBreak)".data(using: .utf8)!)
                body.append("Content-Type: \(mimeType)\(lineBreak + lineBreak)".data(using: .utf8)!)
                body.append(imageData)
            } else {
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)".data(using: .utf8)!)
                body.append("\(value)".data(using: .utf8)!)
            }
            
            body.append(lineBreak.data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        request.httpBody = body
        print("makeMultipartRequest 완료")
        return request
    }
    
    func resultResponse<T: Decodable>(data: Data?, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        print("🚀 StatusCode: \(String(describing: httpResponse.statusCode))")
        
        guard let data = data else {
            throw NetworkError.noData
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
                print("📦 APIResponse 디코딩 결과:", apiResponse)
                
                if let result = apiResponse.data {
                    return result
                } else if T.self == EmptyResponseDTO.self, let emptyResult = EmptyResponseDTO() as? T {
                    return emptyResult
                } else {
                    throw NetworkError.noData
                }
            } catch (let error){
                print("⚠️ APIResponse\(T.self) 디코딩 결과:", error.localizedDescription)
                throw NetworkError.decodingFailed(error)
            }
            
        default:
            let errorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
            print("⚠️ APIErrorResponse 디코딩 결과:", errorResponse)
            
            switch errorResponse.status {
            case 400:
                throw NetworkError.requestFailed(description: "잘못된 경로")
                
            case 401:
                throw NetworkError.tokenExpiration
                
            case 404:
                throw NetworkError.requestFailed(description: errorResponse.message)
                
            default:
                throw NetworkError.unknown
            }
        }
    }
}
