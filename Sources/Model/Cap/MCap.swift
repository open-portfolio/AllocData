//
//  AllocCap.swift
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

public struct MCap: Hashable & AllocBase {
    public static let defaultLimitPct = 1.0

    public var accountID: String // key
    public var assetID: String // key
    public var limitPct: Double

    public static var schema: AllocSchema { .allocCap }

    public init(accountID: String,
                assetID: String,
                limitPct: Double? = nil)
    {
        self.accountID = accountID
        self.assetID = assetID
        self.limitPct = limitPct ?? MCap.defaultLimitPct
    }
}

extension MCap: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accountID = "capAccountID"
        case assetID = "capAssetID"
        case limitPct
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        accountID = try c.decode(String.self, forKey: .accountID)
        assetID = try c.decode(String.self, forKey: .assetID)
        limitPct = try c.decodeIfPresent(Double.self, forKey: .limitPct) ?? MCap.defaultLimitPct
    }
}

extension MCap: CustomStringConvertible {
    public var description: String {
        "accountID=\(accountID) assetID=\(assetID) limitPct=\(String(describing: limitPct))"
    }
}
