//
//  MAccount.swift
//
// Copyright 2021 FlowAllocator LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

public struct MAccount: Hashable & AllocBase {
    public var accountID: String // key
    public var title: String?
    public var isActive: Bool
    public var isTaxable: Bool
    public var canTrade: Bool
    public var strategyID: String

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accountID
        case title
        case isActive
        case isTaxable
        case canTrade
        case strategyID = "accountStrategyID"
    }

    public static var schema: AllocSchema { .allocAccount }

    public static var attributes: [AllocAttribute] = [
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

    public init(accountID: String,
                title: String? = nil,
                isActive: Bool? = nil,
                isTaxable: Bool? = nil,
                canTrade: Bool? = nil,
                strategyID: String? = nil)
    {
        self.accountID = accountID
        self.title = title
        self.isActive = isActive ?? false
        self.isTaxable = isTaxable ?? false
        self.canTrade = canTrade ?? false
        self.strategyID = strategyID ?? AllocNilKey
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        accountID = try c.decode(String.self, forKey: .accountID)
        title = try c.decodeIfPresent(String.self, forKey: .title)
        isActive = try c.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        isTaxable = try c.decodeIfPresent(Bool.self, forKey: .isTaxable) ?? false
        canTrade = try c.decodeIfPresent(Bool.self, forKey: .canTrade) ?? false
        strategyID = try c.decodeIfPresent(String.self, forKey: .strategyID) ?? AllocNilKey
    }

    public init(from row: Row) throws {
        guard let accountID_ = MAccount.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        title = MAccount.getStr(row, CodingKeys.title.rawValue)
        isActive = MAccount.getBool(row, CodingKeys.isActive.rawValue) ?? false
        isTaxable = MAccount.getBool(row, CodingKeys.isTaxable.rawValue) ?? false
        canTrade = MAccount.getBool(row, CodingKeys.canTrade.rawValue) ?? false
        strategyID = MAccount.getStr(row, CodingKeys.strategyID.rawValue) ?? AllocNilKey
    }

    public mutating func update(from row: Row) throws {
        if let val = MAccount.getStr(row, CodingKeys.title.rawValue) { title = val }
        if let val = MAccount.getBool(row, CodingKeys.isActive.rawValue) { isActive = val }
        if let val = MAccount.getBool(row, CodingKeys.isTaxable.rawValue) { isTaxable = val }
        if let val = MAccount.getBool(row, CodingKeys.canTrade.rawValue) { canTrade = val }
        if let val = MAccount.getStr(row, CodingKeys.strategyID.rawValue) { strategyID = val }
    }

    public var primaryKey: AllocKey {
        MAccount.keyify(accountID)
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue = CodingKeys.accountID.rawValue
        guard let accountID_ = getStr(row, rawValue)
        else { throw AllocDataError.invalidPrimaryKey(rawValue) }
        return keyify(accountID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MAccount.CodingKeys.self

        return rawRows.compactMap { row in
            // required values
            guard let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let title = parseString(row[ck.title.rawValue])
            let isActive = parseBool(row[ck.isActive.rawValue])
            let isTaxable = parseBool(row[ck.isTaxable.rawValue])
            let canTrade = parseBool(row[ck.canTrade.rawValue])
            let strategyID = parseString(row[ck.strategyID.rawValue])

            return [
                ck.accountID.rawValue: accountID,
                ck.title.rawValue: title,
                ck.isActive.rawValue: isActive,
                ck.isTaxable.rawValue: isTaxable,
                ck.canTrade.rawValue: canTrade,
                ck.strategyID.rawValue: strategyID,
            ]
        }
    }
}

extension MAccount: CustomStringConvertible {
    public var description: String {
        "accountID=\(accountID) title=\(String(describing: title)) isActive=\(String(describing: isActive)) isTaxable=\(String(describing: isTaxable)) canTrade=\(String(describing: canTrade)) strategyID=\(strategyID)"
    }
}
