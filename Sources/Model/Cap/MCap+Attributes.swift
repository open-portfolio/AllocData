//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MCap {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account in which the limit will be imposed."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset in which the limit will be imposed."),
        AllocAttribute(CodingKeys.limitPct, .double, isRequired: false, isKey: false, "Allocate no more than this fraction of the account's capacity to the asset."),
    ]
}
