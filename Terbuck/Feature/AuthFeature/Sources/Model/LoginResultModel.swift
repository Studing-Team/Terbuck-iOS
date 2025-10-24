//
//  LoginResultModel.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation
import DomainInterface

public struct LoginResultModel {
    let showSignup: Bool
    let userId: Int
    let accessToken: String
    let refreshToken: String
    
    // Entity로부터 Model 생성
    init(from entity: LoginResultEntity) {
        self.showSignup = entity.showSignup
        self.userId = entity.userId
        self.accessToken = entity.accessToken
        self.refreshToken = entity.refreshToken
    }
}
