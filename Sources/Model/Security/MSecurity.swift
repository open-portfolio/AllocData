//
//  AllocSecurity.swift
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

public struct MSecurity: Hashable & AllocBase {
    public var securityID: String
    public var assetID: String
    public var sharePrice: Double?
    public var updatedAt: Date?
    public var trackerID: String

    public static var schema: AllocSchema { .allocSecurity }

    public init(securityID: String,
                assetID: String? = nil,
                sharePrice: Double? = nil,
                updatedAt: Date? = nil,
                trackerID: String? = nil)
    {
        self.securityID = securityID
        self.assetID = assetID ?? AllocNilKey
        self.sharePrice = sharePrice
        self.updatedAt = updatedAt
        self.trackerID = trackerID ?? AllocNilKey
    }
}

extension MSecurity: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case securityID
        case assetID = "securityAssetID"
        case sharePrice
        case updatedAt
        case trackerID = "securityTrackerID"
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        securityID = try c.decode(String.self, forKey: .securityID)
        assetID = try c.decodeIfPresent(String.self, forKey: .assetID) ?? AllocNilKey
        sharePrice = try c.decodeIfPresent(Double.self, forKey: .sharePrice)
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt)
        trackerID = try c.decodeIfPresent(String.self, forKey: .trackerID) ?? AllocNilKey
    }
}

extension MSecurity: CustomStringConvertible {
    public var description: String {
        "securityID=\(securityID) assetID=\(assetID) sharePrice=\(String(describing: sharePrice)) updatedAt=\(String(describing: updatedAt)) trackerID=\(trackerID)"
    }
}
