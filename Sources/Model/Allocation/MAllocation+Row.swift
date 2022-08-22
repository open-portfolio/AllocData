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

extension MAllocation: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let _strategyID = MAllocation.getStr(row, CodingKeys.strategyID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.strategyID.rawValue) }
        strategyID = _strategyID

        guard let _assetID = MAllocation.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = _assetID

        targetPct = MAllocation.getDouble(row, CodingKeys.targetPct.rawValue) ?? MAllocation.defaultTargetPct
        isLocked = MAllocation.getBool(row, CodingKeys.isLocked.rawValue) ?? false
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MAllocation.getDouble(row, CodingKeys.targetPct.rawValue) { targetPct = val }
        if let val = MAllocation.getBool(row, CodingKeys.isLocked.rawValue) { isLocked = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> Key {
        guard let _strategyID = getStr(row, CodingKeys.strategyID.rawValue),
              let _assetID = getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Allocation") }
        return Key(strategyID: _strategyID, assetID: _assetID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MAllocation.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let strategyID = parseString(rawRow[ck.strategyID.rawValue]),
                  strategyID.count > 0,
                  let assetID = parseString(rawRow[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.strategyID.rawValue: strategyID,
                ck.assetID.rawValue: assetID,
            ]

            decodedRow[ck.targetPct.rawValue] = parseDouble(rawRow[ck.targetPct.rawValue]) ?? MAllocation.defaultTargetPct

            if let isLocked = parseBool(rawRow[ck.isLocked.rawValue]) {
                decodedRow[ck.isLocked.rawValue] = isLocked
            }

            array.append(decodedRow)
        }
    }
}
