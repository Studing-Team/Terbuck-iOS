//
//  FetchAdvertisementBannerUseCase.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 10/25/25.
//

import Foundation

public protocol FetchAdvertisementBannerUseCase {
    func execute() async throws -> [BannerItemModel]
}

public struct FetchAdvertisementBannerUseCaseImpl: FetchAdvertisementBannerUseCase {
    private let repository: HomeRepository

    public init(repository: HomeRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [BannerItemModel] {
        let entity = try await repository.getAdvertisementBannerList()
        
        return entity.map {
            BannerItemModel(
                id: $0.id,
                imageUrl: $0.imageUrl,
                linkUrl: $0.linkUrl
            )
        }
    }
}
