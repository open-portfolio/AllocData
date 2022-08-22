//
//  MSale.swift
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

public struct MRebalanceSale: Hashable & AllocBase {
    public var accountID: String // key
    public var securityID: String // key
    public var lotID: String // key
    public var amount: Double
    public var shareCount: Double?
    public var liquidateAll: Bool

    public static var schema: AllocSchema { .allocRebalanceSale }

    public init(accountID: String,
                securityID: String,
                lotID: String,
                amount: Double,
                shareCount: Double? = nil,
                liquidateAll: Bool = false)
    {
        self.accountID = accountID
        self.securityID = securityID
        self.lotID = lotID
        self.amount = amount
        self.shareCount = shareCount
        self.liquidateAll = liquidateAll
    }
}

extension MRebalanceSale: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accountID = "saleAccountID"
        case securityID = "saleSecurityID"
        case lotID = "saleLotID"
        case amount
        case shareCount
        case liquidateAll
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        accountID = try c.decode(String.self, forKey: .accountID)
        securityID = try c.decode(String.self, forKey: .securityID)
        lotID = try c.decodeIfPresent(String.self, forKey: .lotID) ?? ""
        amount = try c.decode(Double.self, forKey: .amount)
        shareCount = try c.decodeIfPresent(Double.self, forKey: .shareCount)
        liquidateAll = try c.decodeIfPresent(Bool.self, forKey: .liquidateAll) ?? false
    }
}

extension MRebalanceSale: CustomStringConvertible {
    public var description: String {
        "accountID=\(accountID) securityID=\(securityID) lotID=\(lotID) amount=\(String(format: "%.2f", amount)) shareCount=\(String(describing: shareCount)) liquidateAll=\(liquidateAll)"
    }
}
