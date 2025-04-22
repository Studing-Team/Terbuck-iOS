//
//  MypageType.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/16/25.
//

import Foundation

///
/// 이 열거형은 UICollectionViewCompositionalLayout을 사용하는 마이페이지에서
/// 각 섹션의 타입을 구분하고 관련 데이터를 제공합니다.
///
/// - Note: `CaseIterable` 프로토콜을 채택하여 모든 케이스를 순회할 수 있습니다.
///
/// ## 사용 예시
/// ```swift
/// let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
///     let sectionType = MyPageType.allCases[sectionIndex]
///     switch sectionType {
///     case .alarmSetting:
///         return createMyInfoSection()
///     case .appService, .userInfo:
///         return createCommonSection()
///     }
/// }
/// ```
enum MyPageType: CaseIterable {
    /// 유저 정보를 표시하는 섹션
    case userInfo
    
    /// 알림 관련한 옵션을 표시하는 섹션
    case alarmSetting
    
    /// 앱 사용과 관련된 정보를 표시하는 섹션
    case appService
    
    /// 회원, 인증 관련한 표시하는 섹션
    case userAuth
    
    /// 각 섹션에 표시될 항목들의 제목 배열을 반환합니다.
    ///
    /// - Returns: 섹션 내 항목 제목 문자열 배열
    var items: [String] {
        switch self {
        case .userInfo: return [""]
        case .alarmSetting: return ["알림"]
        case .appService: return ["문의하기", "서비스 이용안내", "개인정보 처리방침"]
        case .userAuth: return ["로그아웃", "회원탈퇴"]
        }
    }
}
