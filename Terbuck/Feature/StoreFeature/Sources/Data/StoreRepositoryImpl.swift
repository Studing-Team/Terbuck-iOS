//
//  StoreRepositoryImpl.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 5/29/25.
//

import Foundation

import Foundation
import CoreNetwork

public protocol StoreRepository {
    func getSearchStoreMap(university: String, category: String, latitude: String, longitude: String) async throws -> [SearchStoreMapEntity]
    func getSearchDetailStore(storeId: Int) async throws -> SearchDetailStoreEntity
}

struct StoreRepositoryImpl: StoreRepository {
    private let networkManager = NetworkManager.shared
    
    func getSearchStoreMap(university: String, category: String, latitude: String, longitude: String) async throws -> [SearchStoreMapEntity] {
        let requestDTO = SearchStoreMapRequestDTO(university: university, category: category, latitude: latitude, longitude: longitude)
        let dto: SearchStoreMapResponseDTO = try await networkManager.request(StoreAPIEndpoint.getMapStore(requestDTO))
        
        return dto.list.map { $0.toEntity() }
    }
    
    func getSearchDetailStore(storeId: Int) async throws -> SearchDetailStoreEntity {
        let requestDTO = SearchDetailStoreIdRequestDTO(shop_Id: storeId)
        let dto: SearchStoreDetailResponseDTO = try await networkManager.request(StoreAPIEndpoint.getDetailStore(requestDTO))
        
        return dto.toEntity()
    }
}
