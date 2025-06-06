//
//  SearchStoreMapUseCase.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import Foundation
import CoreNetwork
import DesignSystem

public protocol SearchStoreMapUseCase {
    func execute(category: String, latitude: String, longitude: String) async throws -> [StoreListModel]
}

public struct SearchStoreMapUseCaseImpl: SearchStoreMapUseCase {
    private let repository: StoreRepository

    public init(repository: StoreRepository) {
        self.repository = repository
    }

    public func execute(category: String, latitude: String, longitude: String) async throws -> [StoreListModel] {
        
        let universityName = UserDefaults.standard.string(forKey: "University") ?? ""

        let entity = try await repository.getSearchStoreMap(university: universityName, category: category, latitude: latitude, longitude: longitude)
        
        return entity.map {
            StoreListModel(
                id: $0.id,
                imageURL: $0.storeImageURL,
                storeName: $0.name,
                storeAddress: $0.address,
                category: CategoryType.from(category),
                benefitCount: $0.benefitCount,
                latitude: $0.latitude,
                longitude: $0.longitude
            )
        }
    }
}
