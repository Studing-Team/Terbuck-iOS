//
//  StudentIDCardFlowDelegate.swift
//  Shared
//
//  Created by ParkJunHyuk on 4/25/25.
//

import Foundation

public protocol StudentIDCardFlowDelegate: AnyObject {
    func showOnboardiing(location: CGRect)
    func showAuthStudentID()
    func registerStudentID()
    func dismissAuthStudentID()
}
