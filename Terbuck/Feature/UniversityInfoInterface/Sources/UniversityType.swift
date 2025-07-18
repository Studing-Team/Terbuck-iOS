//
//  UniversityType.swift
//  UniversityInfoInterface
//
//  Created by ParkJunHyuk on 7/9/25.
//

import Foundation

public enum UniversityType {
    case register
    case edit
    
    public var title: String {
        switch self {
        case .register:
            return "회원가입"
        case .edit:
            return "학교 변경"
        }
    }
}
