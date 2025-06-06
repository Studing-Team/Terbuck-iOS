//
//  University.swift
//  Shared
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation

public enum University {
    case kw
    case ss
    case sam
    case sung
    
    public var title: String {
        switch self {
        case .kw: return "광운대학교"
        case .sam: return "삼육대학교"
        case .ss: return "서울과학기술대학교"
        case .sung: return "성신여자대학교"
        }
    }
}
