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
    
    // MARK: - Codable
    
    public func set<T: Encodable>(object: T, for key: UserDefaultsKey) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            defaults.set(data, forKey: key.rawValue)
            AppLogger.log("UserDefaults - \(key.rawValue)에 Codable 객체 저장", .info, .manager)
        } catch {
            AppLogger.log("UserDefaults - \(key.rawValue)에 객체 인코딩 실패: \(error)", .error, .manager)
        }
    }
    
    public func get<T: Decodable>(objectType: T.Type, for key: UserDefaultsKey) -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else {
            AppLogger.log("UserDefaults - \(key.rawValue)에 해당하는 데이터 없음", .debug, .manager)
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(objectType, from: data)
            AppLogger.log("UserDefaults - \(key.rawValue)에서 Codable 객체 조회", .debug, .manager)
            return object
        } catch {
            AppLogger.log("UserDefaults - \(key.rawValue)에서 객체 디코딩 실패: \(error)", .error, .manager)
            return nil
        }
    }

    // MARK: - Remove
    
    public func remove(_ key: UserDefaultsKey) {
        AppLogger.log("UserDefaults - \(key.rawValue) 삭제", .info, .manager)
        defaults.removeObject(forKey: key.rawValue)
    }
}
