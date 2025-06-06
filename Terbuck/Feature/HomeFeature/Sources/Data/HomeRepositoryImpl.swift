//
//  HomeRepositoryImpl.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/27/25.
//

import Foundation
import CoreNetwork

public protocol HomeRepository {
    func getSearchStore(university: String, category: String) async throws -> [SearchStoreEntity]
    func getSearchPartner(university: String) async throws -> [SearchPartnershipEntity]
    func getSearchNewPartner(university: String) async throws -> [SearchPartnershipEntity]
    func getDetailPartner(partnershipId: Int) async throws -> DetailPartnershipEntity
}

struct HomeRepositoryImpl: HomeRepository {
    private let networkManager = NetworkManager.shared
    
    func getSearchStore(university: String, category: String) async throws -> [SearchStoreEntity] {
        let requestDTO = SearchStoreRequestDTO(university: university, category: category)
        let dto: StoreBenefitResponseDTO = try await networkManager.request(StoreAPIEndpoint.getHomeStore(requestDTO))
        
        return dto.list.map { $0.toEntity() }
    }
    
    func getSearchPartner(university: String) async throws -> [SearchPartnershipEntity] {
        let requestDTO = UniversityRequestDTO(university: university)
        let dto: SearchPartnershipResponseDTO = try await networkManager.request(PartnershipAPIEndpoint.getPartnership(requestDTO))
        
        return dto.list.map { $0.toEntity() }
    }
    
    func getSearchNewPartner(university: String) async throws -> [SearchPartnershipEntity] {
        let requestDTO = UniversityRequestDTO(university: university)
        let dto: SearchPartnershipResponseDTO = try await networkManager.request(PartnershipAPIEndpoint.getNewPartnership(requestDTO))
        
        return dto.list.map { $0.toEntity() }
    }
    
    func getDetailPartner(partnershipId: Int) async throws -> DetailPartnershipEntity {
        let requestDTO = PartnershipIDRequestDTO(partnership_id: partnershipId)
        let dto: DetailPartnershipResponseDTO = try await networkManager.request(PartnershipAPIEndpoint.getDetailPartnership(requestDTO))
        
        return dto.toEntity()
    }
}
