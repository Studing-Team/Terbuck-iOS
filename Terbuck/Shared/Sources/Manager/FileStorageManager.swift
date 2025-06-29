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
            AppLogger.log("\(type.rawValue) 저장 성공", .info, .manager)
            return true
        } catch {
            AppLogger.log("\(type.rawValue) 저장 실패: \(error.localizedDescription)", .error, .manager)
            return false
        }
    }
    
    // MARK: - Save Json
    
    public func saveJSON<T: Codable>(_ object: T, type: FileType) -> Bool {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url)
            AppLogger.log("JSON 객체(\(type.rawValue)) 저장 성공", .info, .manager)
            return true
        } catch {
            AppLogger.log("JSON 객체(\(type.rawValue)) 저장 실패: \(error.localizedDescription)", .error, .manager)
            return false
        }
    }

    // MARK: - Load Data
    
    public func load(type: FileType) -> Data? {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        do {
            let data = try Data(contentsOf: url)
            AppLogger.log("\(type.rawValue) 불러오기 성공", .info, .manager)
            return data
        } catch {
            AppLogger.log("\(type.rawValue) 불러오기 실패 (파일이 없을 수 있음): \(error.localizedDescription)", .debug, .manager)
            return nil
        }
    }
    
    // MARK: - Load Json
    
    public func loadJSON<T: Codable>(type: FileType, as typeOf: T.Type) -> T? {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        do {
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            AppLogger.log("JSON 객체(\(type.rawValue)) 불러오기 성공", .info, .manager)
            return object
        } catch {
            // ⚠️ 실패 로그 (파일 읽기 또는 디코딩 오류)
            AppLogger.log("JSON 객체(\(type.rawValue)) 불러오기 실패: \(error.localizedDescription)", .error, .manager)
            return nil
        }
    }

    // MARK: - Delete Data
    
    public func delete(type: FileType) {
        let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
        do {
            // 삭제 시도 전에 파일이 있는지 먼저 확인
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
                AppLogger.log("\(type.rawValue) 삭제 성공", .info, .manager)
            } else {
                AppLogger.log("\(type.rawValue) 삭제 시도 (파일이 이미 없음)", .debug, .manager)
            }
        } catch {
            // ⚠️ 파일이 있는데도 삭제에 실패한 경우는 심각한 오류
            AppLogger.log("\(type.rawValue) 삭제 실패: \(error.localizedDescription)", .error, .manager)
        }
    }

    // MARK: - Check Exists
    
    public func exists(type: FileType) -> Bool {
            let url = getDocumentsDirectory().appendingPathComponent(type.rawValue)
            let fileExists = fileManager.fileExists(atPath: url.path)
            // 💬 존재 여부 확인은 상세 디버깅 정보
            AppLogger.log("FileStorage \(type.rawValue) 존재 여부 확인: \(fileExists)", .debug, .manager)
            return fileExists
        }

    // MARK: - Documents Directory
    
    private func getDocumentsDirectory() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
