//
//  MTransaction.swift
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

public struct MTransaction: Hashable & AllocBase {
    public var action: Action // key
    public var transactedAt: Date // key
    public var accountID: String // key
    public var securityID: String // key
    public var lotID: String // key
    public var shareCount: Double // key
    public var sharePrice: Double?
    public var realizedGainShort: Double?
    public var realizedGainLong: Double?

    public static var schema: AllocSchema { .allocTransaction }

    public init(action: Action,
                transactedAt: Date,
                accountID: String,
                securityID: String,
                lotID: String = "",
                shareCount: Double = 0,
                sharePrice: Double? = nil,
                realizedGainShort: Double? = nil,
                realizedGainLong: Double? = nil)
    {
        self.action = action
        self.transactedAt = transactedAt
        self.accountID = accountID
        self.securityID = securityID
        self.lotID = lotID
        self.shareCount = shareCount
        self.sharePrice = sharePrice
        self.realizedGainShort = realizedGainShort
        self.realizedGainLong = realizedGainLong
    }
}

extension MTransaction: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action = "txnAction"
        case transactedAt = "txnTransactedAt"
        case accountID = "txnAccountID"
        case securityID = "txnSecurityID"
        case lotID = "txnLotID"
        case shareCount = "txnShareCount"
        case sharePrice = "txnSharePrice"
        case realizedGainShort
        case realizedGainLong
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        action = try c.decode(Action.self, forKey: .action)
        transactedAt = try c.decodeIfPresent(Date.self, forKey: .transactedAt) ?? Date(timeIntervalSinceReferenceDate: 0)
        accountID = try c.decodeIfPresent(String.self, forKey: .accountID) ?? ""
        securityID = try c.decodeIfPresent(String.self, forKey: .securityID) ?? ""
        lotID = try c.decodeIfPresent(String.self, forKey: .lotID) ?? ""
        shareCount = try c.decodeIfPresent(Double.self, forKey: .shareCount) ?? 0
        sharePrice = try c.decodeIfPresent(Double.self, forKey: .sharePrice)
        realizedGainShort = try c.decodeIfPresent(Double.self, forKey: .realizedGainShort)
        realizedGainLong = try c.decodeIfPresent(Double.self, forKey: .realizedGainLong)
    }

    // needed to properly encode the enum
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(action, forKey: .action)
        try c.encode(transactedAt, forKey: .transactedAt)
        try c.encode(accountID, forKey: .accountID)
        try c.encode(securityID, forKey: .securityID)
        try c.encode(lotID, forKey: .lotID)
        try c.encode(shareCount, forKey: .shareCount)
        try c.encode(sharePrice, forKey: .sharePrice)
        try c.encode(realizedGainShort, forKey: .realizedGainShort)
        try c.encode(realizedGainLong, forKey: .realizedGainLong)
    }
}

extension MTransaction: CustomStringConvertible {
    public var description: String {
        "action=\(action) transactedAt=\(String(describing: transactedAt)) accountID=\(accountID) securityID=\(securityID) lotID=\(lotID) shareCount=\(String(describing: shareCount)) sharePrice=\(String(describing: sharePrice)) realizedGainShort=\(String(describing: realizedGainShort)) realizedGainLong=\(String(describing: realizedGainLong))"
    }
}
