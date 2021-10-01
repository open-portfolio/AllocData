//
//  MAccount.swift
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

public struct MAccount: Hashable & AllocBase {
    public var accountID: String // key
    public var title: String?
    public var isActive: Bool
    public var isTaxable: Bool
    public var canTrade: Bool
    public var strategyID: String

    public static var schema: AllocSchema { .allocAccount }

    public init(accountID: String,
                title: String? = nil,
                isActive: Bool? = nil,
                isTaxable: Bool? = nil,
                canTrade: Bool? = nil,
                strategyID: String? = nil)
    {
        self.accountID = accountID
        self.title = title
        self.isActive = isActive ?? false
        self.isTaxable = isTaxable ?? false
        self.canTrade = canTrade ?? false
        self.strategyID = strategyID ?? ""
    }
}

extension MAccount: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accountID
        case title
        case isActive
        case isTaxable
        case canTrade
        case strategyID = "accountStrategyID"
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        accountID = try c.decode(String.self, forKey: .accountID)
        title = try c.decodeIfPresent(String.self, forKey: .title)
        isActive = try c.decodeIfPresent(Bool.self, forKey: .isActive) ?? false
        isTaxable = try c.decodeIfPresent(Bool.self, forKey: .isTaxable) ?? false
        canTrade = try c.decodeIfPresent(Bool.self, forKey: .canTrade) ?? false
        strategyID = try c.decodeIfPresent(String.self, forKey: .strategyID) ?? ""
    }
}

extension MAccount: CustomStringConvertible {
    public var description: String {
        "accountID=\(accountID) title=\(String(describing: title)) isActive=\(String(describing: isActive)) isTaxable=\(String(describing: isTaxable)) canTrade=\(String(describing: canTrade)) strategyID=\(strategyID)"
    }
}
