//
//  RegisterRepository.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/4/25.
//

import Foundation
import CoreNetwork

public protocol RegisterRepository {
    func putRegisterStudentId(image: Data, name: String, studentId: String) async throws -> Void
}

public struct RegisterRepositoryImpl: RegisterRepository {
    private let networkManager = NetworkManager.shared
    
    public init() {}
    
    public func putRegisterStudentId(image: Data, name: String, studentId: String) async throws {
        let requestDTO = RegisterStudentIDRequestDTO(image: image, name: name, studentNumber: studentId)
        let _: EmptyResponseDTO = try await networkManager.request(MemberAPIEndpoint.putRegisterStudentId(requestDTO))
    }
}
