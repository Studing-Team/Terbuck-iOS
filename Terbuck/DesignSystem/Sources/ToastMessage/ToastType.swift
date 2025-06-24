//
//  ToastType.swift
//  DesignSystem
//
//  Created by ParkJunHyuk on 4/23/25.
//

import UIKit

public enum AuthorizedType {
    case home
    case detailStore
}

public enum ToastType {
    case notAuthorized(type: AuthorizedType)
    case noticeStudentCard
    case alarmStudentCard
    case changeUniversity
    case moreBenefit
    case partnership
    
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
            
        case .moreBenefit:
            return .moreBenefitIcon
            
        case .partnership:
            return .moreBenefitIcon
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
            
        case .moreBenefit:
            return "더 자세한 정보와 후기를 볼 수 있어요"
            
        case .partnership:
            return "문의하려면 아래 버튼을 눌러주세요."
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
        return DesignSystem.Font.uiFont(.textRegular14)
    }
    
    var fontColor: UIColor {
        return DesignSystem.Color.uiColor(.terbuckWhite)
    }
    
    var padding: CGFloat {
        switch self {
        case .notAuthorized(let type):
            if type == .detailStore {
                return 68
            } else {
                return 16
            }
            
        case .noticeStudentCard, .alarmStudentCard, .moreBenefit:
            return 68
            
        case .partnership:
            return 75
            
        default:
            return 16
        }
    }
}
