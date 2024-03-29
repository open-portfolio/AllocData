//
//  MValuationPosition.swift
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

public struct MValuationPosition: Hashable & AllocBase {
    public var snapshotID: String // key
    public var accountID: String // key
    public var assetID: String // key

    public var totalBasis: Double
    public var marketValue: Double

    public static var schema: AllocSchema { .allocValuationPosition }

    public init(
        snapshotID: String,
        accountID: String,
        assetID: String,
        totalBasis: Double = 0,
        marketValue: Double = 0
    ) {
        self.snapshotID = snapshotID
        self.accountID = accountID
        self.assetID = assetID
        self.totalBasis = totalBasis
        self.marketValue = marketValue
    }
}

extension MValuationPosition: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case snapshotID = "valuationPositionSnapshotID"
        case accountID = "valuationPositionAccountID"
        case assetID = "valuationPositionAssetID"
        case totalBasis
        case marketValue
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        snapshotID = try c.decode(String.self, forKey: .snapshotID)
        accountID = try c.decode(String.self, forKey: .accountID)
        assetID = try c.decode(String.self, forKey: .assetID)
        totalBasis = try c.decode(Double.self, forKey: .totalBasis)
        marketValue = try c.decode(Double.self, forKey: .marketValue)
    }
}

extension MValuationPosition: CustomStringConvertible {
    public var description: String {
        "snapshotID=\(snapshotID) accountID=\(accountID) assetID=\(assetID) totalBasis=\(totalBasis) marketValue=\(marketValue)"
    }
}
