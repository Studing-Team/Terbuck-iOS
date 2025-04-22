//
//  MypageNavigationType.swift
//  MypageFeature
//
//  Created by ParkJunHyuk on 4/19/25.
//

import Foundation

/// `MypageNavigationType` 열거형은 마이페이지 화면에서 사용되는 네비게이션 메뉴 항목들을 정의합니다.
/// 알림설정,  서비스 정책 확인, 계정 관리 등 마이페이지의 모든 이동 가능한 항목들을 포함합니다.
///
/// - Note: 각 케이스는 마이페이지에서 특정 화면으로의 이동을 나타내며, 사용자 계정과 관련된 모든 기능을 포함합니다.
///
/// ## 열거형의 각 케이스
///   - `alarmSetting`: 알림 설정 화면으로 이동
///   - `inquiry`: 고객센터 화면으로 이동
///   - `serviceGuide`: 공지사항 화면으로 이동
///   - `privacyPolicy`: 개인정보 처리방침 화면으로 이동
///   - `logout`: 로그아웃 기능
///   - `withDraw`: 회원탈퇴 기능
///
public enum MypageNavigationType {
    /// 알림 설정 화면
    case alarmSetting
    
    /// 문의하기
    case inquiry
    
    /// 서비스 이용 안내
    case serviceGuide
    
    /// 개인정보 처리방침
    case privacyPolicy
    
    /// 로그아웃
    case showLogout
    
    /// 회원탈퇴
    case withdraw
}
