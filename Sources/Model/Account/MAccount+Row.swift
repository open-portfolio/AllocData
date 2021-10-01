//
//  M+Row.swift
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

extension MAccount: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let accountID_ = MAccount.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        title = MAccount.getStr(row, CodingKeys.title.rawValue)
        isActive = MAccount.getBool(row, CodingKeys.isActive.rawValue) ?? false
        isTaxable = MAccount.getBool(row, CodingKeys.isTaxable.rawValue) ?? false
        canTrade = MAccount.getBool(row, CodingKeys.canTrade.rawValue) ?? false
        strategyID = MAccount.getStr(row, CodingKeys.strategyID.rawValue) ?? ""
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MAccount.getStr(row, CodingKeys.title.rawValue) { title = val }
        if let val = MAccount.getBool(row, CodingKeys.isActive.rawValue) { isActive = val }
        if let val = MAccount.getBool(row, CodingKeys.isTaxable.rawValue) { isTaxable = val }
        if let val = MAccount.getBool(row, CodingKeys.canTrade.rawValue) { canTrade = val }
        if let val = MAccount.getStr(row, CodingKeys.strategyID.rawValue) { strategyID = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue = CodingKeys.accountID.rawValue
        guard let accountID_ = getStr(row, rawValue)
        else { throw AllocDataError.invalidPrimaryKey(rawValue) }
        return keyify(accountID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
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
