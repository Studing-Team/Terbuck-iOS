//
//  AppDelegate.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/11/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import UIKit

import CoreKeyChain
import Shared

import KakaoSDKAuth
import KakaoSDKCommon
import Mixpanel

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // UNUserNotificationCenter delegate 설정
        UNUserNotificationCenter.current().delegate = self
        
        // 사용자 분석 툴 초기화 (Mixpanel)
        MixpanelManager.shared.initialize(token: Config.mixpanelKey)
        
        // MARK: - 카카오 로그인 설정
        
        KakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        
        if isFirstLaunchAfterInstall() {
            KeychainManager.shared.clearTokens()
        }
        // Override point for customization after application launch.
        return true
    }
    
    func isFirstLaunchAfterInstall() -> Bool {
        let key = "hasLaunchedBefore"
        let launched = UserDefaults.standard.bool(forKey: key)
        if !launched {
            UserDefaults.standard.set(true, forKey: key)
        }
        return !launched
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Foreground 상태에서 알림 받았을 때 - 알림 표시만 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("포그라운드 알림 수신: \(userInfo)")
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // 알림 눌렀을 때 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // 여기서 알림 클릭 처리
        completionHandler()
    }
}
