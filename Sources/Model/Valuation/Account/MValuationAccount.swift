//
//  MValuationAccount.swift
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

public struct MValuationAccount: Hashable & AllocBase {
    public var snapshotID: String // key
    public var accountID: String // key

    public var strategyID: String

    public static var schema: AllocSchema { .allocValuationAccount }

    public init(
        snapshotID: String,
        accountID: String,
        strategyID: String = MValuationAccount.AllocNilKey
    ) {
        self.snapshotID = snapshotID
        self.accountID = accountID
        self.strategyID = strategyID
    }
}

extension MValuationAccount: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case snapshotID = "valuationAccountSnapshotID"
        case accountID = "valuationAccountAccountID"
        case strategyID
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        snapshotID = try c.decode(String.self, forKey: .snapshotID)
        accountID = try c.decode(String.self, forKey: .accountID)
        strategyID = try c.decodeIfPresent(String.self, forKey: .strategyID) ?? MValuationAccount.AllocNilKey
    }
}

extension MValuationAccount: CustomStringConvertible {
    public var description: String {
        "snapshotID=\(snapshotID) accountID=\(accountID) strategyID=\(strategyID)"
    }
}
