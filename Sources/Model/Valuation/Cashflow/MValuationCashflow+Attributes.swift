//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MValuationCashflow {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.transactedAt, .date, isRequired: true, isKey: true, "The timestamp when this flow occurred."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account in which the flow occurred."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset class flowed."),
        AllocAttribute(CodingKeys.amount, .double, isRequired: true, isKey: false, "The amount of the flow (-Sale, +Purchase)."),
        AllocAttribute(CodingKeys.reconciled, .bool, isRequired: true, isKey: false, "If record was created to reconcile transactions."),
    ]
}
