//
//  MValuationCashflow+Row.swift
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

extension MValuationCashflow: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let _transactedAt = MValuationCashflow.getDate(row, CodingKeys.transactedAt.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.transactedAt.rawValue) }
        transactedAt = _transactedAt

        guard let _accountID = MValuationCashflow.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = _accountID

        guard let _assetID = MValuationCashflow.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = _assetID

        amount = MValuationPosition.getDouble(row, CodingKeys.amount.rawValue) ?? 0
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MValuationPosition.getDouble(row, CodingKeys.amount.rawValue) { amount = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> Key {
        guard let _transactedAt = getDate(row, CodingKeys.transactedAt.rawValue),
              let _accountID = getStr(row, CodingKeys.accountID.rawValue),
              let _assetID = getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Valuation Cashflow") }
//        return makePrimaryKey(transactedAt: _transactedAt, accountID: _accountID, assetID: _assetID)
        return Key(transactedAt: _transactedAt, accountID: _accountID, assetID: _assetID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MValuationCashflow.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let transactedAt = parseDate(rawRow[ck.transactedAt.rawValue]),
                  let accountID = parseString(rawRow[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let assetID = parseString(rawRow[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.transactedAt.rawValue: transactedAt,
                ck.accountID.rawValue: accountID,
                ck.assetID.rawValue: assetID,
            ]

            if let amount = parseDouble(rawRow[ck.amount.rawValue]) {
                decodedRow[ck.amount.rawValue] = amount
            }

            array.append(decodedRow)
        }
    }
}
