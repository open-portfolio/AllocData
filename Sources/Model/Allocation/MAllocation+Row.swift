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

extension MAllocation: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let strategyID_ = MAllocation.getStr(row, CodingKeys.strategyID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.strategyID.rawValue) }
        strategyID = strategyID_

        guard let assetID_ = MAllocation.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        targetPct = MAllocation.getDouble(row, CodingKeys.targetPct.rawValue) ?? MAllocation.defaultTargetPct
        isLocked = MAllocation.getBool(row, CodingKeys.isLocked.rawValue) ?? false
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MAllocation.getDouble(row, CodingKeys.targetPct.rawValue) { targetPct = val }
        if let val = MAllocation.getBool(row, CodingKeys.isLocked.rawValue) { isLocked = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue1 = CodingKeys.strategyID.rawValue
        let rawValue2 = CodingKeys.assetID.rawValue
        guard let strategyID_ = getStr(row, rawValue1),
              let assetID_ = getStr(row, rawValue2)
        else { throw AllocDataError.invalidPrimaryKey("Allocation") }
        return keyify([strategyID_, assetID_])
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MAllocation.CodingKeys.self

        return rawRows.compactMap { row in
            // required values
            guard let strategyID = parseString(row[ck.strategyID.rawValue]),
                  strategyID.count > 0,
                  let assetID = parseString(row[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let targetPct = parseDouble(row[ck.targetPct.rawValue]) ?? MAllocation.defaultTargetPct
            let isLocked = parseBool(row[ck.isLocked.rawValue])

            return [
                ck.strategyID.rawValue: strategyID,
                ck.assetID.rawValue: assetID,
                ck.targetPct.rawValue: targetPct,
                ck.isLocked.rawValue: isLocked,
            ]
        }
    }
}
