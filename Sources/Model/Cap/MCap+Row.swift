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

extension MCap: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let accountID_ = MCap.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let assetID_ = MCap.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        limitPct = MCap.getDouble(row, CodingKeys.limitPct.rawValue) ?? MCap.defaultLimitPct
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MCap.getDouble(row, CodingKeys.limitPct.rawValue) { limitPct = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.assetID.rawValue
        guard let accountID_ = getStr(row, rawValue1),
              let assetID_ = getStr(row, rawValue2)
        else { throw AllocDataError.invalidPrimaryKey("Cap") }
        return keyify([accountID_, assetID_])
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MCap.CodingKeys.self

        return rawRows.compactMap { row in
            // required values
            guard let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let assetID = parseString(row[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let limitPct = parseDouble(row[ck.limitPct.rawValue]) ?? MCap.defaultLimitPct

            return [
                ck.accountID.rawValue: accountID,
                ck.assetID.rawValue: assetID,
                ck.limitPct.rawValue: limitPct,
            ]
        }
    }
}
