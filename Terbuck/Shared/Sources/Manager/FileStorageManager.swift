//
//  FileStorageManager.swift
//  Shared
//
//  Created by ParkJunHyuk on 6/9/25.
//

import Foundation

public struct SearchKeywordModel: Codable {
    public let keyword: String
    public let date: Date
}

public enum FileType: String {
    case studentIdCard = "studentIdCard.jpg"
    case recentSearchKeywords = "recentSearchKeywords.json"
}

public final class FileStorageManager {
    public static let shared = FileStorageManager()
    private init() {}

    private let fileManager = FileManager.default

    // MARK: - Save Data
    
    public func saveData(data: Data, type: FileType) -> Bool {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        do {
            try data.write(to: url)
            print("📥 File save success")
            return true
        } catch {
            print("❌ File save failed:", error)
            return false
        }
    }
    
    // MARK: - Save Json
    
    public func saveJSON<T: Codable>(_ object: T, type: FileType) -> Bool {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url)
            print("📥 \(type.rawValue) save success")
            return true
        } catch {
            print("❌ \(type.rawValue) save failed:", error)
            return false
        }
    }

    // MARK: - Load Data
    
    public func load(type: FileType) -> Data? {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        return try? Data(contentsOf: url)
    }
    
    // MARK: - Load Json
    
    public func loadJSON<T: Codable>(type: FileType, as typeOf: T.Type) -> T? {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        do {
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("❌ \(type.rawValue) load failed:", error)
            return nil
        }
    }

    // MARK: - Delete Data
    
    public func delete(type: FileType) {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        try? fileManager.removeItem(at: url)
    }

    // MARK: - Check Exists
    
    public func exists(type: FileType) -> Bool {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        return fileManager.fileExists(atPath: url.path)
    }

    // MARK: - Documents Directory
    
    private func getDocumentsDirectory() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
