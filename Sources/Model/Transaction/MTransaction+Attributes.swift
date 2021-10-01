//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MTransaction {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.action, .string, isRequired: true, isKey: true, "The type of transaction."),
        AllocAttribute(CodingKeys.transactedAt, .date, isRequired: true, isKey: true, "The date of the transaction."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account in which the transaction occurred."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security involved in the transaction."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the position involved in the transaction (blank if none)."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: true, isKey: true, "The number of shares transacted."),
        AllocAttribute(CodingKeys.sharePrice, .double, isRequired: true, isKey: true, "The price at which the share(s) transacted."),
        AllocAttribute(CodingKeys.realizedGainShort, .double, isRequired: false, isKey: false, "The total short-term realized gain (or loss) from a sale."),
        AllocAttribute(CodingKeys.realizedGainLong, .double, isRequired: false, isKey: false, "The total long-term realized gain (or loss) from a sale."),
    ]
}
