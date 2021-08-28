//
//  MValuationHolding.swift
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

public struct MValuationHolding: Hashable & AllocBase {
    public var snapshotID: String // key
    public var accountID: String // key
    public var securityID: String // key
    public var lotID: String // key
    public var shareCount: Double?
    public var shareBasis: Double?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case snapshotID = "valuationHoldingSnapshotID"
        case accountID = "valuationHoldingAccountID"
        case securityID = "valuationHoldingSecurityID"
        case lotID = "valuationHoldingLotID"
        case shareCount
        case shareBasis
    }

    public static var schema: AllocSchema { .allocValuationHolding }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.snapshotID, .string, isRequired: true, isKey: true, "The snapshot capturing this holding."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account hosting the position."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security of the position."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the position, if any."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: false, isKey: false, "The number of shares held in the position."),
        AllocAttribute(CodingKeys.shareBasis, .double, isRequired: false, isKey: false, "The price paid per share of the security."),
    ]

    public init(snapshotID: String,
                accountID: String,
                securityID: String,
                lotID: String,
                shareCount: Double? = nil,
                shareBasis: Double? = nil)
    {
        self.snapshotID = snapshotID
        self.accountID = accountID
        self.securityID = securityID
        self.lotID = lotID
        self.shareCount = shareCount
        self.shareBasis = shareBasis
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        snapshotID = try c.decode(String.self, forKey: .snapshotID)
        accountID = try c.decode(String.self, forKey: .accountID)
        securityID = try c.decode(String.self, forKey: .securityID)
        lotID = try c.decodeIfPresent(String.self, forKey: .lotID) ?? AllocNilKey
        shareCount = try c.decodeIfPresent(Double.self, forKey: .shareCount)
        shareBasis = try c.decodeIfPresent(Double.self, forKey: .shareBasis)
    }

    public init(from row: Row) throws {
        guard let snapshotID_ = MValuationHolding.getStr(row, CodingKeys.snapshotID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.snapshotID.rawValue) }
        snapshotID = snapshotID_
        
        guard let accountID_ = MValuationHolding.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let securityID_ = MValuationHolding.getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.securityID.rawValue) }
        securityID = securityID_

        lotID = MValuationHolding.getStr(row, CodingKeys.lotID.rawValue) ?? AllocNilKey
        shareCount = MValuationHolding.getDouble(row, CodingKeys.shareCount.rawValue)
        shareBasis = MValuationHolding.getDouble(row, CodingKeys.shareBasis.rawValue)
    }

    public mutating func update(from row: Row) throws {
        if let val = MValuationHolding.getDouble(row, CodingKeys.shareCount.rawValue) { shareCount = val }
        if let val = MValuationHolding.getDouble(row, CodingKeys.shareBasis.rawValue) { shareBasis = val }
    }

    public var primaryKey: AllocKey {
        MValuationHolding.keyify([snapshotID, accountID, securityID, lotID])
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue0 = CodingKeys.snapshotID.rawValue
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.securityID.rawValue
        let rawValue3 = CodingKeys.lotID.rawValue
        guard let snapshotID_ = getStr(row, rawValue0),
              let accountID_ = getStr(row, rawValue1),
              let securityID_ = getStr(row, rawValue2),
              let lotID_ = getStr(row, rawValue3)
        else { throw AllocDataError.invalidPrimaryKey("Valuation Holding") }
        return keyify([snapshotID_, accountID_, securityID_, lotID_])
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MValuationHolding.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let snapshotID = parseString(row[ck.snapshotID.rawValue]),
                  snapshotID.count > 0,
                  let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let securityID = parseString(row[ck.securityID.rawValue]),
                  securityID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // required, but with default value
            let lotID = parseString(row[ck.lotID.rawValue]) ?? AllocNilKey

            // optional values
            let shareCount = parseDouble(row[ck.shareCount.rawValue])
            let shareBasis = parseDouble(row[ck.shareBasis.rawValue])
            
            return [
                ck.snapshotID.rawValue: snapshotID,
                ck.accountID.rawValue: accountID,
                ck.securityID.rawValue: securityID,
                ck.lotID.rawValue: lotID,
                ck.shareCount.rawValue: shareCount,
                ck.shareBasis.rawValue: shareBasis,
            ]
        }
    }
}

extension MValuationHolding: CustomStringConvertible {
    public var description: String {
        "snapshotID=\(snapshotID) accountID=\(accountID) securityID=\(securityID) lotID=\(lotID) shareCount=\(String(describing: shareCount)) shareBasis=\(String(describing: shareBasis))"
    }
}
