//
//  LoginResultModel.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

public struct LoginResultModel {
    let showSignup: Bool
    let userId: Int
    let accessToken: String
    let refreshToken: String
}
