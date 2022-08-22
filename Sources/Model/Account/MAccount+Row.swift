//
//  M+Row.swift
//
// Copyright 2021, 2022 OpenAlloc LLC
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
        guard let _accountID = MAccount.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = _accountID

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

    public static func getPrimaryKey(_ row: DecodedRow) throws -> Key {
        guard let _accountID = getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Account") }
        return Key(accountID: _accountID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MAccount.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let accountID = parseString(rawRow[ck.accountID.rawValue]),
                  accountID.count > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.accountID.rawValue: accountID,
            ]

            if let title = parseString(rawRow[ck.title.rawValue]) {
                decodedRow[ck.title.rawValue] = title
            }
            if let isActive = parseBool(rawRow[ck.isActive.rawValue]) {
                decodedRow[ck.isActive.rawValue] = isActive
            }
            if let isTaxable = parseBool(rawRow[ck.isTaxable.rawValue]) {
                decodedRow[ck.isTaxable.rawValue] = isTaxable
            }
            if let canTrade = parseBool(rawRow[ck.canTrade.rawValue]) {
                decodedRow[ck.canTrade.rawValue] = canTrade
            }
            if let strategyID = parseString(rawRow[ck.strategyID.rawValue]) {
                decodedRow[ck.strategyID.rawValue] = strategyID
            }

            array.append(decodedRow)
        }
    }
}
