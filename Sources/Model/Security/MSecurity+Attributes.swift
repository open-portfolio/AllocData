//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MSecurity {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The symbol/securityID of the security."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: false, isKey: false, "The asset class of the security."),
        AllocAttribute(CodingKeys.sharePrice, .double, isRequired: false, isKey: false, "The reported price of one share of the security."),
        AllocAttribute(CodingKeys.updatedAt, .date, isRequired: false, isKey: false, "The timestamp of the the reported price."),
        AllocAttribute(CodingKeys.trackerID, .string, isRequired: false, isKey: false, "The index the security is tracking."),
    ]
}
