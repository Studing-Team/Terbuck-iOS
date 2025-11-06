//
//  UniversityInfoUseCase.swift
//  UniversityInfoInterface
//
//  Created by ParkJunHyuk on 10/29/25.
//

import Foundation
import DomainInterface

// Member Repository 관련 UseCase
public typealias SignupUseCase = DomainInterface.SignupUseCase
public typealias UpdateUniversityUseCase = DomainInterface.UpdateUniversityUseCase

// University Repository 관련 UseCase
public typealias GetUniversityInfoListUseCase = DomainInterface.GetUniversityInfoListUseCase
public typealias GetCollegesInfoListUseCase = DomainInterface.GetCollegesInfoListUseCase

// Entity
public typealias UniversityInfoEntity = DomainInterface.UniversityInfoEntity
public typealias CollegesInfoEntity = DomainInterface.CollegesInfoEntity