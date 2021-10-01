//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MRebalancePurchase {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account to host the position."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset class of the position to acquire."),
        AllocAttribute(CodingKeys.amount, .double, isRequired: true, isKey: false, "The amount in dollars to acquire."),
    ]
}
