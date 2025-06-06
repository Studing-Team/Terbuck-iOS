//
//  DetailPartnershipUseCase.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/28/25.
//

import Foundation

public protocol DetailPartnershipUseCase {
    func execute(partnershipId: Int) async throws -> (DetailPartnershipModel, [DetailPartnerImageModel], DetailPartnerBenefitModel)
}

public struct DetailPartnershipUseCaseImpl: DetailPartnershipUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }

    public func execute(partnershipId: Int) async throws -> (DetailPartnershipModel, [DetailPartnerImageModel], DetailPartnerBenefitModel) {
        let entity = try await repository.getDetailPartner(partnershipId: partnershipId)
        return convertToModel(entity)
    }
}

extension DetailPartnershipUseCaseImpl {
    func convertToModel(_ entity: DetailPartnershipEntity) -> (DetailPartnershipModel, [DetailPartnerImageModel], DetailPartnerBenefitModel) {
        let headerModel = DetailPartnershipModel(partnershipName: entity.name, partnerCategoryType: PartnerCategoryType.from(entity.institution))
        
        let imageModel = entity.imageList.map {
            DetailPartnerImageModel(DetailPartnerimageURL: $0)
        }
        
        let contentModel = DetailPartnerBenefitModel(content: entity.detail)
        
        return (headerModel, imageModel, contentModel)
    }
}
