//
//  PartnerBenefitItem.swift
//  HomeFeature
//
//  Created by ParkJunHyuk on 5/8/25.
//

import Foundation

public enum PartnerBenefitItem: Hashable {
    case partnerTitleHeader(DetailPartnershipModel)
    case partnerImage([DetailPartnerImageModel]?)
    case benefit(DetailPartnerBenefitModel)
}
