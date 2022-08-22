//
//  MHolding.swift
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

public struct MHolding: Hashable & AllocBase {
    public var accountID: String // key
    public var securityID: String // key
    public var lotID: String // key
    public var shareCount: Double?
    public var shareBasis: Double?
    public var acquiredAt: Date?

    public static var schema: AllocSchema { .allocHolding }

    public init(accountID: String,
                securityID: String,
                lotID: String,
                shareCount: Double? = nil,
                shareBasis: Double? = nil,
                acquiredAt: Date? = nil)
    {
        self.accountID = accountID
        self.securityID = securityID
        self.lotID = lotID
        self.shareCount = shareCount
        self.shareBasis = shareBasis
        self.acquiredAt = acquiredAt
    }
}

extension MHolding: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accountID = "holdingAccountID"
        case securityID = "holdingSecurityID"
        case lotID = "holdingLotID"
        case shareCount
        case shareBasis
        case acquiredAt
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        accountID = try c.decode(String.self, forKey: .accountID)
        securityID = try c.decode(String.self, forKey: .securityID)
        lotID = try c.decodeIfPresent(String.self, forKey: .lotID) ?? ""
        shareCount = try c.decodeIfPresent(Double.self, forKey: .shareCount)
        shareBasis = try c.decodeIfPresent(Double.self, forKey: .shareBasis)
        acquiredAt = try c.decodeIfPresent(Date.self, forKey: .acquiredAt)
    }
}

extension MHolding: CustomStringConvertible {
    public var description: String {
        "accountID=\(accountID) securityID=\(securityID) lotID=\(lotID) shareCount=\(String(describing: shareCount)) shareBasis=\(String(describing: shareBasis)) acquiredAt=\(String(describing: acquiredAt))"
    }
}
