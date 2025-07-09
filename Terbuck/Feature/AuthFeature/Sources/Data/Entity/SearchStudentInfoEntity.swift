//
//  SearchStudentInfoEntity.swift
//  AuthFeature
//
//  Created by ParkJunHyuk on 6/29/25.
//

import Foundation
import CoreNetwork

public struct SearchStudentInfoEntity {
    let studentName: String
    let universityName: String
    let isAuth: Bool
    let studentNum: String?
    let imageUrl: String?
}

extension SearchStudentInfoResponseDTO {
    func toEntity() -> SearchStudentInfoEntity {
        return SearchStudentInfoEntity(
            studentName: name,
            universityName: university,
            isAuth: isRegistered,
            studentNum: studentNumber,
            imageUrl: imageURL
        )
    }
}
