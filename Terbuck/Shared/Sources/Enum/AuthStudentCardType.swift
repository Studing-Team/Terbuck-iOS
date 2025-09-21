//
//  AuthStudentCardType.swift
//  Shared
//
//  Created by ParkJunHyuk on 9/19/25.
//

import Foundation

/// 학생증 버튼 탭 액션을 정의하는 타입
///
/// 사용자의 인증 상태, 온보딩 여부, 심사 상태에 따라 분기되며
/// ViewModel이 이 타입을 반환하면, ViewController는 해당하는 화면으로 이동하거나 메시지를 표시합니다.
public enum AuthStudentCardType {
    /// 미인증 사용자가 학생증 버튼 온보딩을 아직 보지 않은 경우
    case showOnboarding
    
    /// 미인증 사용자가 온보딩을 이미 완료한 경우, 등록을 유도
    case registerMessage
    
    /// 학생증을 제출하여 심사가 진행 중인 경우
    case pendingMessage
    
    /// 학생증 인증이 완료된 사용자의 경우
    case showStudentCard
}
