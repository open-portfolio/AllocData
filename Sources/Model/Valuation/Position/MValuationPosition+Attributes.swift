//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MValuationPosition {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.snapshotID, .string, isRequired: true, isKey: true, "The valuation snapshot ID for the position."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account hosting the position."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset class of the position."),
        AllocAttribute(CodingKeys.totalBasis, .double, isRequired: true, isKey: false, "The price paid to establish position."),
        AllocAttribute(CodingKeys.marketValue, .double, isRequired: true, isKey: false, "The market value of the position."),
    ]
}
