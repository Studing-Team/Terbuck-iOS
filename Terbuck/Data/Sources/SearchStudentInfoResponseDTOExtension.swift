//
//  SearchStudentInfoResponseDTOExtension.swift
//  Data
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation
import CoreNetwork
import DomainInterface

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
