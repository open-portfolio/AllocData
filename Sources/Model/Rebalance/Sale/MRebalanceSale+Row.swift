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

extension MRebalanceSale: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let _accountID = MRebalanceSale.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = _accountID

        guard let _securityID = MRebalanceSale.getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.securityID.rawValue) }
        securityID = _securityID

        lotID = MRebalanceSale.getStr(row, CodingKeys.lotID.rawValue) ?? ""
        amount = MRebalanceSale.getDouble(row, CodingKeys.amount.rawValue) ?? 0
        shareCount = MRebalanceSale.getDouble(row, CodingKeys.shareCount.rawValue)
        liquidateAll = MRebalanceSale.getBool(row, CodingKeys.liquidateAll.rawValue) ?? false
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MRebalanceSale.getDouble(row, CodingKeys.amount.rawValue) { amount = val }
        if let val = MRebalanceSale.getDouble(row, CodingKeys.shareCount.rawValue) { shareCount = val }
        if let val = MRebalanceSale.getBool(row, CodingKeys.liquidateAll.rawValue) { liquidateAll = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> Key {
        guard let _accountID = getStr(row, CodingKeys.accountID.rawValue),
              let _securityID = getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Rebalance Sale") }
        let _lotID = getStr(row, CodingKeys.lotID.rawValue) ?? ""
        return Key(accountID: _accountID, securityID: _securityID, lotID: _lotID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MRebalanceSale.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let accountID = parseString(rawRow[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let securityID = parseString(rawRow[ck.securityID.rawValue]),
                  securityID.count > 0,
                  let amount = parseDouble(rawRow[ck.amount.rawValue]),
                  amount > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.accountID.rawValue: accountID,
                ck.securityID.rawValue: securityID,
                ck.amount.rawValue: amount,
            ]

            // required, but with default value
            if let lotID = parseString(rawRow[ck.lotID.rawValue]) {
                decodedRow[ck.lotID.rawValue] = lotID
            }

            if let shareCount = parseDouble(rawRow[ck.shareCount.rawValue]) {
                decodedRow[ck.shareCount.rawValue] = shareCount
            }
            if let liquidateAll = parseBool(rawRow[ck.liquidateAll.rawValue]) {
                decodedRow[ck.liquidateAll.rawValue] = liquidateAll
            }

            array.append(decodedRow)
        }
    }
}
