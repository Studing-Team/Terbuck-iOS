//
//  ToastType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit

public enum ToastType {
    case notAuthorized
    case noticeStudentCard
    case alarmStudentCard
    case changeUniversity
    
    var image: UIImage {
        switch self {
        case .notAuthorized:
            return .toastNoti
            
        case .noticeStudentCard:
            return .toastInfo
            
        case .alarmStudentCard:
            return .toastAlarm
            
        case .changeUniversity:
            return .toastEdit
        }
    }
    
    var title: String {
        switch self {
        case .notAuthorized:
            return "아직 학생증이 등록되지 않았어요!"
            
        case .noticeStudentCard:
            return "얼굴, 이름, 학번이 보이는 이미지를 넣어주세요"
            
        case .alarmStudentCard:
            return "등록까지 최대 24시간이 걸려요"
            
        case .changeUniversity:
            return "학교가 변경되었어요"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .notAuthorized:
            return "등록하기"
        
        case .alarmStudentCard:
            return "알림받기"
            
        case .changeUniversity:
            return "학생증 재등록"
            
        default:
            return ""
        }
    }
    
    var font: UIFont {
        return .textRegular14
    }
    
    var fontColor: UIColor {
        return .terbuckWhite
    }
}
