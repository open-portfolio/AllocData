//
//  MValuationPosition.swift
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

public struct MValuationPosition: Hashable & AllocBase {
    public var snapshotID: String // key
    public var accountID: String // key
    public var securityID: String // key
    public var lotID: String // key

    public var shareBasis: Double
    public var shareCount: Double
    public var sharePrice: Double
    public var assetID: String

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case snapshotID = "valuationPositionSnapshotID"
        case accountID = "valuationPositionAccountID"
        case securityID = "valuationPositionSecurityID"
        case lotID = "valuationPositionLotID"
        case shareCount
        case shareBasis
        case sharePrice
        case assetID
    }

    public static var schema: AllocSchema { .allocValuationPosition }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.snapshotID, .string, isRequired: true, isKey: true, "The valuation snapshot ID for the position."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account hosting the position."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security/ticker of the position."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the position, if any."),
        AllocAttribute(CodingKeys.shareBasis, .double, isRequired: true, isKey: false, "The price paid per share of the security to establish position."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: true, isKey: false, "The number of shares remaining in the position."),
        AllocAttribute(CodingKeys.sharePrice, .double, isRequired: true, isKey: false, "The price per share at the snapshot."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: false, "The asset class of the security."),
    ]

    public init(
        snapshotID: String,
        accountID: String,
        securityID: String,
        lotID: String,
        shareBasis: Double,
        shareCount: Double,
        sharePrice: Double,
        assetID: String
    ) {
        self.snapshotID = snapshotID
        self.accountID = accountID
        self.securityID = securityID
        self.lotID = lotID
        self.shareBasis = shareBasis
        self.shareCount = shareCount
        self.sharePrice = sharePrice
        self.assetID = assetID
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        snapshotID = try c.decode(String.self, forKey: .snapshotID)
        accountID = try c.decode(String.self, forKey: .accountID)
        securityID = try c.decode(String.self, forKey: .securityID)
        lotID = try c.decodeIfPresent(String.self, forKey: .lotID) ?? AllocNilKey
        shareBasis = try c.decode(Double.self, forKey: .shareBasis)
        shareCount = try c.decode(Double.self, forKey: .shareCount)
        sharePrice = try c.decode(Double.self, forKey: .sharePrice)
        assetID = try c.decode(String.self, forKey: .assetID)
    }

    public init(from row: Row) throws {
        guard let snapshotID_ = MValuationPosition.getStr(row, CodingKeys.snapshotID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.snapshotID.rawValue) }
        snapshotID = snapshotID_

        guard let accountID_ = MValuationPosition.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let securityID_ = MValuationPosition.getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.securityID.rawValue) }
        securityID = securityID_

        lotID = MValuationPosition.getStr(row, CodingKeys.lotID.rawValue) ?? AllocNilKey

        shareBasis = MValuationPosition.getDouble(row, CodingKeys.shareBasis.rawValue) ?? 0
        shareCount = MValuationPosition.getDouble(row, CodingKeys.shareCount.rawValue) ?? 0
        sharePrice = MValuationPosition.getDouble(row, CodingKeys.sharePrice.rawValue) ?? 0
        assetID = MValuationPosition.getStr(row, CodingKeys.assetID.rawValue) ?? AllocNilKey
    }

    public mutating func update(from row: Row) throws {
        if let val = MValuationPosition.getDouble(row, CodingKeys.shareBasis.rawValue) { shareBasis = val }
        if let val = MValuationPosition.getDouble(row, CodingKeys.shareCount.rawValue) { shareCount = val }
        if let val = MValuationPosition.getDouble(row, CodingKeys.sharePrice.rawValue) { sharePrice = val }
        if let val = MValuationPosition.getStr(row, CodingKeys.assetID.rawValue) { assetID = val }
    }

    public var primaryKey: AllocKey {
        MValuationPosition.makePrimaryKey(snapshotID: snapshotID, accountID: accountID, securityID: securityID, lotID: lotID)
    }

    public static func makePrimaryKey(snapshotID: String, accountID: String, securityID: String, lotID: String) -> AllocKey {
        keyify([snapshotID, accountID, securityID, lotID])
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
        else { throw AllocDataError.invalidPrimaryKey("Position") }
        return makePrimaryKey(snapshotID: snapshotID_, accountID: accountID_, securityID: securityID_, lotID: lotID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MValuationPosition.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let snapshotID = parseString(row[ck.snapshotID.rawValue]),
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
            let shareBasis = parseDouble(row[ck.shareBasis.rawValue])
            let shareCount = parseDouble(row[ck.shareCount.rawValue])
            let sharePrice = parseDouble(row[ck.sharePrice.rawValue])
            let assetID = parseString(row[ck.assetID.rawValue])

            return [
                ck.snapshotID.rawValue: snapshotID,
                ck.accountID.rawValue: accountID,
                ck.securityID.rawValue: securityID,
                ck.lotID.rawValue: lotID,
                ck.shareBasis.rawValue: shareBasis,
                ck.shareCount.rawValue: shareCount,
                ck.sharePrice.rawValue: sharePrice,
                ck.assetID.rawValue: assetID,
            ]
        }
    }
}

extension MValuationPosition: CustomStringConvertible {
    public var description: String {
       "snapshotID=\(snapshotID) accountID=\(accountID) securityID=\(securityID) lotID=\(lotID) shareBasis=\(shareBasis) shareCount=\(shareCount) sharePrice=\(sharePrice) assetID=\(assetID)"
    }
}
