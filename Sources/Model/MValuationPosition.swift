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
    public var assetID: String // key

    public var totalBasis: Double
    public var marketValue: Double

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case snapshotID = "valuationPositionSnapshotID"
        case accountID = "valuationPositionAccountID"
        case assetID = "valuationPositionAssetID"
        case totalBasis
        case marketValue
    }

    public static var schema: AllocSchema { .allocValuationPosition }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.snapshotID, .string, isRequired: true, isKey: true, "The valuation snapshot ID for the position."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account hosting the position."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset class of the position."),
        AllocAttribute(CodingKeys.totalBasis, .double, isRequired: true, isKey: false, "The price paid to establish position."),
        AllocAttribute(CodingKeys.marketValue, .double, isRequired: true, isKey: false, "The market value of the position."),
    ]

    public init(
        snapshotID: String,
        accountID: String,
        assetID: String,
        totalBasis: Double,
        marketValue: Double
    ) {
        self.snapshotID = snapshotID
        self.accountID = accountID
        self.assetID = assetID
        self.totalBasis = totalBasis
        self.marketValue = marketValue
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        snapshotID = try c.decode(String.self, forKey: .snapshotID)
        accountID = try c.decode(String.self, forKey: .accountID)
        assetID = try c.decode(String.self, forKey: .assetID)
        totalBasis = try c.decode(Double.self, forKey: .totalBasis)
        marketValue = try c.decode(Double.self, forKey: .marketValue)
    }

    public init(from row: Row) throws {
        guard let snapshotID_ = MValuationPosition.getStr(row, CodingKeys.snapshotID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.snapshotID.rawValue) }
        snapshotID = snapshotID_

        guard let accountID_ = MValuationPosition.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let assetID_ = MValuationPosition.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        totalBasis = MValuationPosition.getDouble(row, CodingKeys.totalBasis.rawValue) ?? 0
        marketValue = MValuationPosition.getDouble(row, CodingKeys.marketValue.rawValue) ?? 0
    }

    public mutating func update(from row: Row) throws {
        if let val = MValuationPosition.getDouble(row, CodingKeys.totalBasis.rawValue) { totalBasis = val }
        if let val = MValuationPosition.getDouble(row, CodingKeys.marketValue.rawValue) { marketValue = val }
    }

    public var primaryKey: AllocKey {
        MValuationPosition.makePrimaryKey(snapshotID: snapshotID, accountID: accountID, assetID: assetID)
    }

    public static func makePrimaryKey(snapshotID: String, accountID: String, assetID: String) -> AllocKey {
        keyify([snapshotID, accountID, assetID])
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue0 = CodingKeys.snapshotID.rawValue
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.assetID.rawValue
        guard let snapshotID_ = getStr(row, rawValue0),
              let accountID_ = getStr(row, rawValue1),
              let assetID_ = getStr(row, rawValue2)
        else { throw AllocDataError.invalidPrimaryKey("Position") }
        return makePrimaryKey(snapshotID: snapshotID_, accountID: accountID_, assetID: assetID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MValuationPosition.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let snapshotID = parseString(row[ck.snapshotID.rawValue]),
                  let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let assetID = parseString(row[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let totalBasis = parseDouble(row[ck.totalBasis.rawValue])
            let marketValue = parseDouble(row[ck.marketValue.rawValue])

            return [
                ck.snapshotID.rawValue: snapshotID,
                ck.accountID.rawValue: accountID,
                ck.assetID.rawValue: assetID,
                ck.totalBasis.rawValue: totalBasis,
                ck.marketValue.rawValue: marketValue,
            ]
        }
    }
}

extension MValuationPosition: CustomStringConvertible {
    public var description: String {
       "snapshotID=\(snapshotID) accountID=\(accountID) assetID=\(assetID) totalBasis=\(totalBasis) marketValue=\(marketValue)"
    }
}
