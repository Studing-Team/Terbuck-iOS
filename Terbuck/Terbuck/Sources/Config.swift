//
//  Config.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 5/21/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let naverId = "NMFClientId"
            static let naverMap = "NAVER_MAP_KEY"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found !!!")
        }
        return dict
    }()
}

extension Config {
    static let naverIdKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.naverId] as? String else {
            fatalError("⛔️NAVER_MAP_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
    
    static let naverMapKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.naverMap] as? String else {
            fatalError("⛔️NAVER_MAP_KEY is not set in plist for this configuration⛔️")
        }
        return key
    }()
}
