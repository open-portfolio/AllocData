//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MRebalanceSale {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account hosting the position."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security of the position."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the position, if any."),
        AllocAttribute(CodingKeys.amount, .double, isRequired: true, isKey: false, "The amount in dollars to liquidate from this position."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: false, isKey: false, "Estimated number of shares to liquidate from this position."),
        AllocAttribute(CodingKeys.liquidateAll, .bool, isRequired: false, isKey: false, "If true, the entire position can be liquidated."),
    ]
}
