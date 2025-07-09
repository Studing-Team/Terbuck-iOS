//
//  APIResponse.swift
//  Core
//
//  Created by ParkJunHyuk on 5/25/25.
//

import Foundation

public struct APIResponse<T: Decodable>: Decodable {
    let status: Int
    let message: String
    let data: T?
}

public struct APIErrorResponse: Decodable {
    let status: Int
    let message: String
}
