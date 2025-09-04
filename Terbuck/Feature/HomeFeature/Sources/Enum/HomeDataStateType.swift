//
//  HomeDataStateType.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 9/4/25.
//

import Foundation

/// 홈 화면의 데이터 상태를 나타내는 열거형
public enum HomeDataStateType {
    /// 로딩 중인 상태
    case loading
    /// 데이터가 없는 초기 상태 (제휴 요청 전)
    case noData
    /// 제휴 요청이 완료된 상태
    case requestPartner
    /// 데이터가 존재하는 상태
    case existData
}
