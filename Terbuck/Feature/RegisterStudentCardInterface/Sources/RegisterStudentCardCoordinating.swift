//
//  RegisterStudentCardCoordinating.swift
//  RegisterStudentCardInterface
//
//  Created by ParkJunHyuk on 7/9/25.
//

import Shared
import Foundation

public protocol RegisterStudentCardCoordinating: Coordinator {
    var delegate: RegisterStudentCardCoordinatorDelegate? { get set }
    
    func showRegisterStudentCard()
    func showStudentIdCard(location: CGRect?, type: AuthStudentUIType)
    func dismissAuthStudentID()
    func didFinishRegistration()
}
