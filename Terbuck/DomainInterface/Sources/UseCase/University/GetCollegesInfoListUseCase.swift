//
//  GetCollegesInfoListUseCase.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation

public protocol GetCollegesInfoListUseCase {
    func execute(university: String) async throws -> [CollegesInfoEntity]
}