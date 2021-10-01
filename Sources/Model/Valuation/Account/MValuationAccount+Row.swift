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
        guard let snapshotID_ = MValuationAccount.getStr(row, CodingKeys.snapshotID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.snapshotID.rawValue) }
        snapshotID = snapshotID_

        guard let accountID_ = MValuationAccount.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let strategyID_ = MValuationAccount.getStr(row, CodingKeys.strategyID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.strategyID.rawValue) }
        strategyID = strategyID_

        strategyID = MValuationAccount.getStr(row, CodingKeys.strategyID.rawValue) ?? MValuationAccount.AllocNilKey
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MValuationPosition.getStr(row, CodingKeys.strategyID.rawValue) { strategyID = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue0 = CodingKeys.snapshotID.rawValue
        let rawValue1 = CodingKeys.accountID.rawValue
        guard let snapshotID_ = getStr(row, rawValue0),
              let accountID_ = getStr(row, rawValue1)
        else { throw AllocDataError.invalidPrimaryKey("Valuation Account") }
        return makePrimaryKey(snapshotID: snapshotID_, accountID: accountID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MValuationAccount.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let snapshotID = parseString(row[ck.snapshotID.rawValue]),
                  let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let strategyID = parseString(row[ck.strategyID.rawValue]) ?? MValuationAccount.AllocNilKey

            return [
                ck.snapshotID.rawValue: snapshotID,
                ck.accountID.rawValue: accountID,
                ck.strategyID.rawValue: strategyID,
            ]
        }
    }
}
