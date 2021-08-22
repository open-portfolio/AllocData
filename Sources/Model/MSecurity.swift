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

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case securityID
        case assetID = "securityAssetID"
        case sharePrice
        case updatedAt
        case trackerID = "securityTrackerID"
    }

    public static var schema: AllocSchema { .allocSecurity }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The symbol/securityID of the security."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: false, isKey: false, "The asset class of the security."),
        AllocAttribute(CodingKeys.sharePrice, .double, isRequired: false, isKey: false, "The reported price of one share of the security."),
        AllocAttribute(CodingKeys.updatedAt, .date, isRequired: false, isKey: false, "The timestamp of the the reported price."),
        AllocAttribute(CodingKeys.trackerID, .string, isRequired: false, isKey: false, "The index the security is tracking."),
    ]

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

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        securityID = try c.decode(String.self, forKey: .securityID)
        assetID = try c.decodeIfPresent(String.self, forKey: .assetID) ?? AllocNilKey
        sharePrice = try c.decodeIfPresent(Double.self, forKey: .sharePrice)
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt)
        trackerID = try c.decodeIfPresent(String.self, forKey: .trackerID) ?? AllocNilKey
    }

    public init(from row: Row) throws {
        guard let securityID_ = MSecurity.getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.securityID.rawValue) }
        securityID = securityID_

        assetID = MSecurity.getStr(row, CodingKeys.assetID.rawValue) ?? AllocNilKey
        sharePrice = MSecurity.getDouble(row, CodingKeys.sharePrice.rawValue)
        updatedAt = MSecurity.getDate(row, CodingKeys.updatedAt.rawValue)
        trackerID = MSecurity.getStr(row, CodingKeys.trackerID.rawValue) ?? AllocNilKey
    }

    public mutating func update(from row: Row) throws {
        if let val = MSecurity.getStr(row, CodingKeys.assetID.rawValue) { assetID = val }
        if let val = MSecurity.getDouble(row, CodingKeys.sharePrice.rawValue) { sharePrice = val }
        if let val = MSecurity.getDate(row, CodingKeys.updatedAt.rawValue) { updatedAt = val }
        if let val = MSecurity.getStr(row, CodingKeys.trackerID.rawValue) { trackerID = val }
    }

    public var primaryKey: AllocKey {
        MSecurity.keyify(securityID)
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue = CodingKeys.securityID.rawValue
        guard let securityID_ = getStr(row, rawValue)
        else { throw AllocDataError.invalidPrimaryKey(rawValue) }
        return keyify(securityID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MSecurity.CodingKeys.self

        return rawRows.compactMap { row in
            // required values
            guard let securityID = parseString(row[ck.securityID.rawValue]),
                  securityID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let assetID = parseString(row[ck.assetID.rawValue])
            let sharePrice = parseDouble(row[ck.sharePrice.rawValue])
            let trackerID = parseString(row[ck.trackerID.rawValue])

            let rawUpdatedAt = row[ck.updatedAt.rawValue]
            let updatedAt = MSecurity.parseDate(rawUpdatedAt)

            return [
                ck.securityID.rawValue: securityID,
                ck.assetID.rawValue: assetID,
                ck.sharePrice.rawValue: sharePrice,
                ck.updatedAt.rawValue: updatedAt,
                ck.trackerID.rawValue: trackerID,
            ]
        }
    }
}

extension MSecurity: CustomStringConvertible {
    public var description: String {
        "securityID=\(securityID) assetID=\(assetID) sharePrice=\(String(describing: sharePrice)) updatedAt=\(String(describing: updatedAt)) trackerID=\(trackerID)"
    }
}
