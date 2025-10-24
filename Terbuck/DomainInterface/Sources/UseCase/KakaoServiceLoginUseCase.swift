//
//  KakaoServiceLoginUseCase.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public protocol KakaoServiceLoginUseCase {
    func execute() async throws -> (token: String, user: String)
}