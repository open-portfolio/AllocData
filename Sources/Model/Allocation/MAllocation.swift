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

    public static var schema: AllocSchema { .allocAllocation }

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
}

extension MAllocation: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case strategyID = "allocationStrategyID"
        case assetID = "allocationAssetID"
        case targetPct
        case isLocked
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        strategyID = try c.decode(String.self, forKey: .strategyID)
        assetID = try c.decode(String.self, forKey: .assetID)
        targetPct = try c.decodeIfPresent(Double.self, forKey: .targetPct) ?? MAllocation.defaultTargetPct
        isLocked = try c.decodeIfPresent(Bool.self, forKey: .isLocked) ?? false
    }
}

extension MAllocation: CustomStringConvertible {
    public var description: String {
        "strategyID=\(strategyID) assetID=\(assetID) targetPct=\(String(format: "%.2f", targetPct)) isLocked=\(isLocked)"
    }
}
