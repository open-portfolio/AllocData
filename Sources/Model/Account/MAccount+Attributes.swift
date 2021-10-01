//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MAccount {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID,
                       .string,
                       isRequired: true,
                       isKey: true,
                       "The account number of the account."),
        AllocAttribute(CodingKeys.title,
                       .string,
                       isRequired: false,
                       isKey: false,
                       "The title of the account."),
        AllocAttribute(CodingKeys.isActive,
                       .bool,
                       isRequired: false,
                       isKey: false,
                       "Is the account active?"),
        AllocAttribute(CodingKeys.isTaxable,
                       .bool,
                       isRequired: false,
                       isKey: false,
                       "Is the account taxable?"),
        AllocAttribute(CodingKeys.canTrade,
                       .bool,
                       isRequired: false,
                       isKey: false,
                       "Can you trade securities in the account?"),
        AllocAttribute(CodingKeys.strategyID,
                       .string,
                       isRequired: false,
                       isKey: false,
                       "The strategy associated with this account, if any."),
    ]
}
