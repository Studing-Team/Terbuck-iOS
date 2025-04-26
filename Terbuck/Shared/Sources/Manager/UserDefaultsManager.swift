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
        defaults.set(value, forKey: key.rawValue)
    }

    public func bool(for key: UserDefaultsKey) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }

    // MARK: - String
    
    public func set(_ value: String, for key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    public func string(for key: UserDefaultsKey) -> String? {
        return defaults.string(forKey: key.rawValue)
    }

    // MARK: - Remove
    
    public func remove(_ key: UserDefaultsKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
