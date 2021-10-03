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

extension MValuationAccount: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let _snapshotID = MValuationAccount.getStr(row, CodingKeys.snapshotID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.snapshotID.rawValue) }
        snapshotID = _snapshotID

        guard let _accountID = MValuationAccount.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = _accountID

        guard let _strategyID = MValuationAccount.getStr(row, CodingKeys.strategyID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.strategyID.rawValue) }
        strategyID = _strategyID

        strategyID = MValuationAccount.getStr(row, CodingKeys.strategyID.rawValue) ?? ""
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MValuationPosition.getStr(row, CodingKeys.strategyID.rawValue) { strategyID = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        guard let _snapshotID = getStr(row, CodingKeys.snapshotID.rawValue),
              let _accountID = getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Valuation Account") }
        return makePrimaryKey(snapshotID: _snapshotID, accountID: _accountID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MValuationAccount.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let snapshotID = parseString(rawRow[ck.snapshotID.rawValue]),
                  let accountID = parseString(rawRow[ck.accountID.rawValue]),
                  accountID.count > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.snapshotID.rawValue: snapshotID,
                ck.accountID.rawValue: accountID,
            ]

            if let strategyID = parseString(rawRow[ck.strategyID.rawValue]) {
                decodedRow[ck.strategyID.rawValue] = strategyID
            }

            array.append(decodedRow)
        }
    }
}
