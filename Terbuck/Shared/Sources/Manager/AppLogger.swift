//
//  AppLogger.swift
//  Shared
//
//  Created by ParkJunHyuk on 6/27/25.
//  Copyright © 2025 Fouryears. All rights reserved.
//

import Foundation
import os

// MARK: - App Logger
// 앱 전체에서 사용할 중앙 로깅 시스템입니다.
// OSLog를 기반으로 하며, Debug/Release 빌드에 따라 다르게 동작합니다.
//
// 사용법:
// AppLogger.log("네트워크 요청 시작")
// AppLogger.log("유저 정보 파싱 실패", .error, .model)

public enum AppLogger {
    
    // MARK: - Log Category
    // 로그를 필터링하기 위한 카테고리입니다.
    public enum LogCategory: String {
        case ui = "UI"
        case network = "Network"
        case model = "Model"
        case viewModel = "ViewModel"
        case `default` = "Default"
        case service = "Service"
        case manager = "Manager"
    }
    
    // MARK: - Log Level
    // 로그의 중요도를 나타내는 레벨입니다.
    
    public enum LogLevel {
        case debug    // 상세한 디버깅 정보
        case info     // 유용한 진행 정보
        case error    // 해결 가능한 오류
        case fault    // 심각한 시스템 장애
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug:    return .debug
            case .info:     return .info
            case .error:    return .error
            case .fault:    return .fault
            }
        }
        
        fileprivate var icon: String {
            switch self {
            case .debug:    return "💬"
            case .info:     return "✅"
            case .error:    return "⚠️"
            case .fault:    return "❌"
            }
        }
    }
    
    // MARK: - Logger Instances
    // 카테고리별 OSLog 인스턴스를 관리합니다.
    
    private static let subsystem = Bundle.main.bundleIdentifier!
    private static var loggers: [String: Logger] = [:]

    private static func logger(for category: LogCategory) -> Logger {
        let categoryString = category.rawValue
        if let logger = loggers[categoryString] {
            return logger
        } else {
            let newLogger = Logger(subsystem: subsystem, category: categoryString)
            loggers[categoryString] = newLogger
            return newLogger
        }
    }
    
    // MARK: - Logging Method
    
    /// 앱의 중앙 로깅 함수입니다.
    /// - Parameters:
    ///   - message: 로그로 남길 메시지.
    ///   - level: 로그의 중요도 (기본값: .debug).
    ///   - category: 로그의 분류 (기본값: .default).
    ///   - file: 로그가 남겨진 파일 경로 (자동 할당).
    ///   - function: 로그가 남겨진 함수 이름 (자동 할당).
    ///   - line: 로그가 남겨진 라인 번호 (자동 할당).
    public static func log(
        _ message: Any,
        _ level: LogLevel = .debug,
        _ category: LogCategory = .default,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
            // DEBUG 모드에서는 항상 print로 콘솔에 보기 쉽게 출력
            let fileName = (file as NSString).lastPathComponent
            let logMessage = "\(level.icon) [\(fileName):\(line)] \(function) - \(message)"
            print(logMessage)
        #endif
        
        // OSLog 시스템에는 Release 모드에서도 error와 fault를 기록하도록 전달
        // DEBUG 모드에서는 모든 레벨의 로그가 OSLog에도 기록되어 Console.app으로 필터링 가능
        #if !DEBUG
            if level == .error || level == .fault {
                let logger = self.logger(for: category)
                let logMessageForOS = "[\((file as NSString).lastPathComponent):\(line)] \(function) - \(String(describing: message))"
                logger.log(level: level.osLogType, "\(logMessageForOS)")
            }
        #else
            let logger = self.logger(for: category)
            let logMessageForOS = "[\((file as NSString).lastPathComponent):\(line)] \(function) - \(String(describing: message))"
            logger.log(level: level.osLogType, "\(logMessageForOS)")
        #endif
    }
}
