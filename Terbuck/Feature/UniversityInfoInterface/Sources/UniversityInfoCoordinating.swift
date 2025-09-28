//
//  UniversityInfoCoordinating.swift
//  UniversityInfoInterface
//
//  Created by ParkJunHyuk on 7/9/25.
//

import Shared

public protocol UniversityInfoCoordinating: Coordinator {
    var delegate: UniversityInfoCoordinatorDelegate? { get set }
    
    func showUniversity()
    func showCollege(selectUniversityName: String)
    func didFinishUniversityInfo()
    func backNavigation()
}
