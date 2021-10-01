//
//  MRebalanceAllocation.swift
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

public struct MRebalanceAllocation: Hashable & AllocBase {
    public var accountID: String // key
    public var assetID: String // key
    public var amount: Double

    public static var schema: AllocSchema { .allocRebalanceAllocation }

    public init(accountID: String,
                assetID: String,
                amount: Double)
    {
        self.accountID = accountID
        self.assetID = assetID
        self.amount = amount
    }
}

extension MRebalanceAllocation: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accountID = "allocationAccountID"
        case assetID = "allocationAssetID"
        case amount
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        accountID = try c.decode(String.self, forKey: .accountID)
        assetID = try c.decode(String.self, forKey: .assetID)
        amount = try c.decode(Double.self, forKey: .amount)
    }
}

extension MRebalanceAllocation: CustomStringConvertible {
    public var description: String {
        "accountID=\(accountID) assetID=\(assetID) amount=\(String(format: "%.2f", amount))"
    }
}
