//
//  SearchDetailStoreIdRequestDTO.swift
//  CoreNetwork
//
//  Created by ParkJunHyuk on 6/4/25.
//

import Foundation

public struct SearchDetailStoreIdRequestDTO: QueryParameterConvertible {
    let shop_Id: Int
    
    public init(shop_Id: Int) {
        self.shop_Id = shop_Id
    }
}
