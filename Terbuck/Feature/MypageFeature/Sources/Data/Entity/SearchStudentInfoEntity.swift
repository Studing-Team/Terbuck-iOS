//
//  SearchStudentInfoEntity.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import CoreNetwork

public struct SearchStudentInfoEntity {
    let studentNum: String
    let studentName: String
    let imageUrl: String
}

extension SearchStudentInfoResponseDTO {
    func toEntity() -> SearchStudentInfoEntity {
        return SearchStudentInfoEntity(
            studentNum: studentNumber,
            studentName: name,
            imageUrl: imageURL
        )
    }
}
