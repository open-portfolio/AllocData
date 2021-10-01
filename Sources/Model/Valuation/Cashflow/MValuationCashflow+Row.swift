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

extension MValuationCashflow: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let transactedAt_ = MValuationCashflow.getDate(row, CodingKeys.transactedAt.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.transactedAt.rawValue) }
        transactedAt = transactedAt_

        guard let accountID_ = MValuationCashflow.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let assetID_ = MValuationCashflow.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        amount = MValuationPosition.getDouble(row, CodingKeys.amount.rawValue) ?? 0
        reconciled = MValuationPosition.getBool(row, CodingKeys.reconciled.rawValue) ?? false
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MValuationPosition.getDouble(row, CodingKeys.amount.rawValue) { amount = val }
        if let val = MValuationPosition.getBool(row, CodingKeys.reconciled.rawValue) { reconciled = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue0 = CodingKeys.transactedAt.rawValue
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.assetID.rawValue
        guard let transactedAt_ = getDate(row, rawValue0),
              let accountID_ = getStr(row, rawValue1),
              let assetID_ = getStr(row, rawValue2)
        else { throw AllocDataError.invalidPrimaryKey("Cashflow") }
        return makePrimaryKey(transactedAt: transactedAt_, accountID: accountID_, assetID: assetID_)
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
            if let reconciled = parseBool(rawRow[ck.reconciled.rawValue]) {
                decodedRow[ck.reconciled.rawValue] = reconciled
            }

            array.append(decodedRow)
        }
    }
}
