//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MHolding {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account hosting the position."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security of the position."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the position, if any."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: false, isKey: false, "The number of shares held in the position."),
        AllocAttribute(CodingKeys.shareBasis, .double, isRequired: false, isKey: false, "The price paid per share of the security."),
        AllocAttribute(CodingKeys.acquiredAt, .date, isRequired: false, isKey: false, "The date of the acquisition."),
    ]
}
