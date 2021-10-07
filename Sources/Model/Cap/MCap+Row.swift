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
        guard let _accountID = MCap.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = _accountID

        guard let _assetID = MCap.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = _assetID

        limitPct = MCap.getDouble(row, CodingKeys.limitPct.rawValue) ?? MCap.defaultLimitPct
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MCap.getDouble(row, CodingKeys.limitPct.rawValue) { limitPct = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        guard let _accountID = getStr(row, CodingKeys.accountID.rawValue),
              let _assetID = getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Cap") }
        return Key(accountID: _accountID, assetID: _assetID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MCap.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let accountID = parseString(rawRow[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let assetID = parseString(rawRow[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.accountID.rawValue: accountID,
                ck.assetID.rawValue: assetID,
            ]

            if let limitPct = parseDouble(rawRow[ck.limitPct.rawValue]) {
                decodedRow[ck.limitPct.rawValue] = limitPct
            }

            array.append(decodedRow)
        }
    }
}
