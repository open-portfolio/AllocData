//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MRebalanceAllocation {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account to which the asset is allocated."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset class of the allocation."),
        AllocAttribute(CodingKeys.amount, .double, isRequired: true, isKey: false, "The amount in dollars allocated."),
    ]
}
