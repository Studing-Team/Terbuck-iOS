//
//  SearchStoreUseCase.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import Shared

public protocol SearchStoreUseCase {
    func execute(category: String) async throws -> [NearStoreModel]
}

public struct SearchStoreUseCaseImpl: SearchStoreUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func execute(category: String) async throws -> [NearStoreModel] {
        
        let universityName = UserDefaultsManager.shared.string(for: .university) ?? ""
        
        let entity = try await repository.getSearchStore(university: universityName, category: category)
        
        return entity.map {
            NearStoreModel(
                id: $0.id,
                storeName: $0.name,
                category: $0.category,
                address: $0.address,
                mainBenefit: $0.benefits[0].title,
                subBenefit: $0.benefits.dropFirst().map { $0.title }
            )
        }
    }
}
