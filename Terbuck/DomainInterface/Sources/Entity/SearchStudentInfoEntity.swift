//
//  SearchStudentInfoEntity.swift
//  DomainInterface
//
//  Created by ParkJunHyuk on 10/23/25.
//

import Foundation

public struct SearchStudentInfoEntity {
    public let studentName: String
    public let universityName: String
    public let isAuth: Bool
    public let studentNum: String?
    public let imageUrl: String?
    
    public init(studentName: String, universityName: String, isAuth: Bool, studentNum: String?, imageUrl: String?) {
        self.studentName = studentName
        self.universityName = universityName
        self.isAuth = isAuth
        self.studentNum = studentNum
        self.imageUrl = imageUrl
    }
}