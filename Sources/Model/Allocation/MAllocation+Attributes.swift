//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MAllocation {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.strategyID, .string, isRequired: true, isKey: true, "The strategy associated with this allocation."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset of the allocation."),
        AllocAttribute(CodingKeys.targetPct, .double, isRequired: false, isKey: false, "The fraction of the asset in the strategy."),
        AllocAttribute(CodingKeys.isLocked, .bool, isRequired: false, isKey: false, "Whether the targetPct is locked (or floating)."),
    ]
}
