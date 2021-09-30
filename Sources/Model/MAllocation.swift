//
//  MAllocation.swift
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

public struct MAllocation: Hashable & AllocBase {
    public static let defaultTargetPct = 0.0

    public var strategyID: String // key
    public var assetID: String // key
    public var targetPct: Double
    public var isLocked: Bool

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case strategyID = "allocationStrategyID"
        case assetID = "allocationAssetID"
        case targetPct
        case isLocked
    }

    public static var schema: AllocSchema { .allocAllocation }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.strategyID, .string, isRequired: true, isKey: true, "The strategy associated with this allocation."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset of the allocation."),
        AllocAttribute(CodingKeys.targetPct, .double, isRequired: false, isKey: false, "The fraction of the asset in the strategy."),
        AllocAttribute(CodingKeys.isLocked, .bool, isRequired: false, isKey: false, "Whether the targetPct is locked (or floating)."),
    ]

    public init(strategyID: String,
                assetID: String,
                targetPct: Double? = nil,
                isLocked: Bool? = nil)
    {
        self.strategyID = strategyID
        self.assetID = assetID
        self.targetPct = targetPct ?? MAllocation.defaultTargetPct
        self.isLocked = isLocked ?? false
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        strategyID = try c.decode(String.self, forKey: .strategyID)
        assetID = try c.decode(String.self, forKey: .assetID)
        targetPct = try c.decodeIfPresent(Double.self, forKey: .targetPct) ?? MAllocation.defaultTargetPct
        isLocked = try c.decodeIfPresent(Bool.self, forKey: .isLocked) ?? false
    }

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

    public var primaryKey: AllocKey {
        MAllocation.keyify([strategyID, assetID])
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

extension MAllocation: CustomStringConvertible {
    public var description: String {
        "strategyID=\(strategyID) assetID=\(assetID) targetPct=\(String(format: "%.2f", targetPct)) isLocked=\(isLocked)"
    }
}
