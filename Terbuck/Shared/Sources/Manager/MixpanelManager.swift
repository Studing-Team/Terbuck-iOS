//
//  MixpanelManager.swift
//  Shared
//
//  Created by ParkJunHyuk on 6/25/25.
//

import Foundation
import Mixpanel

public final class MixpanelManager {
    public static let shared = MixpanelManager()

    private var mixpanel: MixpanelInstance?

    private init() { }

    public func initialize(token: String) {
        self.mixpanel = Mixpanel.initialize(token: token)
        AppLogger.log("Mixpanel SDK 초기화 완료", .info, .service)
    }
    
    public func setupUser(userId: Int) {
        AppLogger.log("유저 식별 시도", .info, .service)
        AppLogger.log("Mixpanel UserId: \(userId)", .debug, .service)
        
        mixpanel?.identify(distinctId: "\(userId)")
    }
    
    public func setupUniversity(universityName: String) {
        AppLogger.log("유저 프로퍼티(학교) 설정", .info, .service)
        AppLogger.log("학교 이름: \(universityName)", .debug, .service)
        
        mixpanel?.people.set(properties: ["$school" : universityName])
    }

    public func track(eventType: String, properties: Properties? = nil) {
        AppLogger.log("이벤트 트래킹: \(eventType)", .info, .service)
        
        mixpanel?.track(event: eventType, properties: properties)
    }
}

// MARK: - TrackEventType

public struct TrackEventType {
    public struct Onboarding {
        public static let kakaoLogin = "click_login_kakao"
        public static let appleLogin = "click_login_apple"
        public static let registerButtonTapped = "click_onboarding_register"
        public static let laterButtonTapped = "click_onboarding_later"
    }
    
    public struct Signup {
        public static let firstSignupButtonTapped = "click_signup1"
        public static let secondSignupButtonTapped = "click_signup2"
    }
    
    public struct Home {
        public static let eatingButtonTapped = "click_top_tab_eating"
        public static let usingButtonTapped = "click_top_tab_using"
        public static let partnershipButtonTapped = "click_top_tab_partnership"
        public static let homeTabBarButtonTapped = "click_bottom_tab_home"
        public static let terbuckTabBarButtonTapped = "click_bottom_tab_terbuck"
        public static let mypageTabBarButtonTapped = "click_bottom_tab_mypage"
        public static let moreBenefitButtonTapped = "click_home_benefit"
        public static let moveDetailPartnership = "move_partnership_detail"
        public static let moveInstagram = "move_partnership_to_instagram"
        public static let studentCardButtonTapped = "click_student_card"
        public static let registerButtonInToastMessage = "click_student_card_register_toast"
        public static let registerButtonTappedInRegisterView = "click_student_card_register"
        public static let alarmButtonInToastMessage = "click_push_alarm_toast"
    }
    
    public struct TerbuckMap {
        public static let allCategoryButtonTapped = "click_category_all"
        public static let foodCategoryButtonTapped = "click_category_food"
        public static let cafeCategoryButtonTapped = "click_category_cafe"
        public static let drinkCategoryButtonTapped = "click_category_drink"
        public static let hospitalCategoryButtonTapped = "click_category_hospital"
        public static let exerciseCategoryButtonTapped = "click_category_exercise"
        public static let cultureCategoryButtonTapped = "click_category_culture"
        public static let studyCategoryButtonTapped = "click_category_study"
        public static let mapMarkerButtonTapped = "click_map_pin"
        public static let myLocationButtonTapped = "click_map_gps"
        public static let searchBarTapped = "click_map_searchbar"
        public static let searchResultTapped = "click_map_search_result"
    }
    
    public struct DetailStore {
        public static let studentCardButtonTapped = "click_detail_student_card"
        public static let moreBenefitButtonTapped = "click_detail_more_info"
        public static let moreUseInfoTapped = "click_detail_usage_info"
        public static let moveNaver = "move_detail_to_naver"
    }
    
    public struct Mypage {
        public static let editUniversityButtonTapped = "click_mypage_edit_univ"
        public static let alarmMenuButtonTapped = "click_mypage_alarm"
        public static let alarmSettingButtonTapped = "move_alarm_to_setting"
        public static let askMenuButtonTapped = "click_mypage_ask"
        public static let serviceMenuButtonTapped = "click_mypage_service"
        public static let personalMenuButtonTapped = "click_mypage_personal_info"
        public static let logoutMenuButtonTapped = "click_mypage_logout"
        public static let logoutConfirmButtonTapped = "click_mypage_logout_confirm"
        public static let signoutMenuButtonTapped = "click_mypage_signout"
        public static let signoutConfirmButtonTapped = "click_mypage_signout_confirm"
    }
}
