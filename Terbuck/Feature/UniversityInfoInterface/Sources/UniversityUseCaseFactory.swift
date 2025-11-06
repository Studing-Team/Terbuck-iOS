//
//  UniversityUseCaseFactory.swift
//  UniversityInfoInterface
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation
import DomainInterface

// Member Repository Factory
public typealias SignupUseCaseFactory = DomainInterface.SignupUseCaseFactory
public typealias UpdateUniversityUseCaseFactory = DomainInterface.UpdateUniversityUseCaseFactory

// University Repository Factory
public typealias GetUniversityInfoListUseCaseFactory = DomainInterface.GetUniversityInfoListUseCaseFactory
public typealias GetCollegesInfoListUseCaseFactory = DomainInterface.GetCollegesInfoListUseCaseFactory