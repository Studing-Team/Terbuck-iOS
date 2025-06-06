//
//  SearchDetailStoreUseCase.swift
//  StoreFeature
//
//  Created by ParkJunHyuk on 6/4/25.
//

import Foundation
import CoreNetwork

public protocol SearchDetailStoreUseCase {
    func execute(storeId: Int) async throws -> (DetailStoreHeaderModel, [DetailStoreImageModel]?, [DetailStoreBenefitModel], String)
}

public struct SearchDetailStoreUseCaseImpl: SearchDetailStoreUseCase {
    private let repository: StoreRepository

    public init(repository: StoreRepository) {
        self.repository = repository
    }

    public func execute(storeId: Int) async throws -> (DetailStoreHeaderModel, [DetailStoreImageModel]?, [DetailStoreBenefitModel], String){
        let entity = try await repository.getSearchDetailStore(storeId: storeId)
        
        return convertToModel(entity)
    }
}

extension SearchDetailStoreUseCaseImpl {
    func convertToModel(_ entity: SearchDetailStoreEntity) -> (DetailStoreHeaderModel, [DetailStoreImageModel]?, [DetailStoreBenefitModel], String) {
        
        let headerModel = DetailStoreHeaderModel(storeName: entity.storeName, storeAddress: entity.address)
        
        let imageModel = entity.storeImageURL.map {
            DetailStoreImageModel(DetailStoreimageURL: $0)
        }
        
        let contentModel = entity.benefitList.map {
            DetailStoreBenefitModel(benefitTitle: $0.title, detailList: $0.detailList)
        }
        
        return (headerModel, imageModel, contentModel, entity.storeURL)
    }
}
