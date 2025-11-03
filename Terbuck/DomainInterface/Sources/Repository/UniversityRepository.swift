//
//  UniversityRepository.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation

public protocol UniversityRepository {
    func getUniversityInfoList() async throws -> [UniversityInfoEntity]
    func getCollegesInfoList(university: String) async throws -> [CollegesInfoEntity]
}