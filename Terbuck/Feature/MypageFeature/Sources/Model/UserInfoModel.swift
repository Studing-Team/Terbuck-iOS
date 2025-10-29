//
//  UserInfoModel.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/17/25.
//

import Foundation
import MypageInterface

public struct UserInfoModel {
    let userName: String
    let studentId: String?
    let university: String
    let isAuthenticated: Bool
    let imageUrl: String?
    
    // Entity로부터 Model 생성
    init(from entity: SearchStudentInfoEntity) {
        self.userName = entity.studentName
        self.studentId = entity.studentNum
        self.university = entity.universityName
        self.isAuthenticated = entity.isAuth
        self.imageUrl = entity.imageUrl
    }
}
