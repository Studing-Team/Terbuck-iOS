//
//  FileStorageManager.swift
//  Shared
//
//  Created by ParkJunHyuk on 6/9/25.
//

import Foundation

public enum FileType: String {
    case studentIdCard = "studentIdCard.jpg"
}

public final class FileStorageManager {
    public static let shared = FileStorageManager()
    private init() {}

    private let fileManager = FileManager.default

    // MARK: - Save Data
    
    public func save(data: Data, type: FileType) -> Bool {
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

    // MARK: - Load Data
    
    public func load(type: FileType) -> Data? {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        return try? Data(contentsOf: url)
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
