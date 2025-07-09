//
//  SearchPartnershipUseCase.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/28/25.
//

import Foundation
import Shared

public protocol SearchPartnershipUseCase {
    func searchExecute() async throws -> [PartnershipModel]
    func newSearchExecute() async throws -> [PartnershipModel]
}

public struct SearchPartnershipUseCaseImpl: SearchPartnershipUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func searchExecute() async throws -> [PartnershipModel] {
        let universityName = UserDefaultsManager.shared.string(for: .university) ?? ""
        
        let entity = try await repository.getSearchPartner(university: universityName)
        return convertToModel(entity, false)
    }
    
    public func newSearchExecute() async throws -> [PartnershipModel] {
        let universityName = UserDefaultsManager.shared.string(for: .university) ?? ""
        
        let entity = try await repository.getSearchNewPartner(university: universityName)
        return convertToModel(entity, true)
    }
}

private extension SearchPartnershipUseCaseImpl {
    func convertToModel(_ entity: [SearchPartnershipEntity], _ newData: Bool) -> [PartnershipModel] {
        return entity.map {
            PartnershipModel(
                id: $0.id,
                partnershipName: $0.name,
                partnerCategoryType: PartnerCategoryType.from($0.institution),
                storeType: PartnerStoreType.from($0.category),
                isNewPartner: newData
            )
        }
    }
}
