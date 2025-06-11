//
//  MypageCoordinating.swift
//  MypageInterface
//
//  Created by ParkJunHyuk on 4/19/25.
//

import Shared

public protocol MypageCoordinating: Coordinator {
    var delegate: notAuthCoordinatorDelegate? { get set }
    
    func startMypage()
    func startAlarmSetting()
}
