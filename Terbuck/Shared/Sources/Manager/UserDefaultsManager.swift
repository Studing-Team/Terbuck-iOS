//
//  UserDefaultsManager.swift
//  Shared
//
//  Created by ParkJunHyuk on 4/26/25.
//

import Foundation

public final class UserDefaultsManager {
    public static let shared = UserDefaultsManager()
    private init() {}

    private let defaults = UserDefaults.standard
    
    // MARK: - Bool
    
    public func set(_ value: Bool, for key: UserDefaultsKey) {
        AppLogger.log("UserDefaults - \(key.rawValue)에 Bool 값 '\(value)' 저장", .info, .manager)
        defaults.set(value, forKey: key.rawValue)
    }

    public func bool(for key: UserDefaultsKey) -> Bool {
        let value = defaults.bool(forKey: key.rawValue)
        AppLogger.log("UserDefaults - \(key.rawValue)에서 Bool 값 '\(value)' 조회", .debug, .manager)
        return value
    }

    // MARK: - String
    
    public func set(_ value: String, for key: UserDefaultsKey) {
        AppLogger.log("UserDefaults - \(key.rawValue)에 String 값 저장", .info, .manager)
        AppLogger.log("저장된 값(String): \(value)", .debug, .manager)
        defaults.set(value, forKey: key.rawValue)
    }

    public func string(for key: UserDefaultsKey) -> String? {
        let value = defaults.string(forKey: key.rawValue)
        AppLogger.log("UserDefaults - \(key.rawValue)에서 String 값 조회", .debug, .manager)
        return value
    }

    // MARK: - Remove
    
    public func remove(_ key: UserDefaultsKey) {
        AppLogger.log("UserDefaults - \(key.rawValue) 삭제", .info, .manager)
        defaults.removeObject(forKey: key.rawValue)
    }
}
