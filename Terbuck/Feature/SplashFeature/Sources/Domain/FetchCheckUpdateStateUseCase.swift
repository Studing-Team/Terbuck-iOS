//
//  FetchCheckUpdateStateUseCase.swift
//  SplashFeature
//
//  Created by ParkJunHyuk on 9/26/25.
//

import Foundation

public protocol FetchCheckUpdateStateUseCase {
    func execute(version: String) async throws -> Bool
}

public struct FetchCheckUpdateStateUseCaseImpl: FetchCheckUpdateStateUseCase {
    let repository: SplashRepository
    
    public func execute(version: String) async throws -> Bool {
        let entity = try await repository.getCheckUpdateState(version: version)
        return entity.isUpdateAvailable
    }
}
