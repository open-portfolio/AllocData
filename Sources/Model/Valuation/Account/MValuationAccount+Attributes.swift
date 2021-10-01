//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MValuationAccount {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.snapshotID, .string, isRequired: true, isKey: true, "The valuation snapshot ID for the account."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account identifier"),
        AllocAttribute(CodingKeys.strategyID, .string, isRequired: true, isKey: false, "The strategy assignment for the account at the time."),
    ]
}
