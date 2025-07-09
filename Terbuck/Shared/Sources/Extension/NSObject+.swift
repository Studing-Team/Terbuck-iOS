//
//  NSObject+.swift
//  Terbuck
//
//  Created by ParkJunHyuk on 4/8/25.
//

import Foundation

public extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
