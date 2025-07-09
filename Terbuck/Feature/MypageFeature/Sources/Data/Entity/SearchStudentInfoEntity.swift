//
//  SearchStudentInfoEntity.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
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
