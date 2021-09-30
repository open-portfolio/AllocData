//
//  MPurchase.swift
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

public struct MRebalancePurchase: Hashable & AllocBase {
    public var accountID: String // key
    public var assetID: String // key
    public var amount: Double

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accountID = "purchaseAccountID"
        case assetID = "purchaseAssetID"
        case amount
    }

    public static var schema: AllocSchema { .allocRebalancePurchase }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account to host the position."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset class of the position to acquire."),
        AllocAttribute(CodingKeys.amount, .double, isRequired: true, isKey: false, "The amount in dollars to acquire."),
    ]

    public init(accountID: String,
                assetID: String,
                amount: Double)
    {
        self.accountID = accountID
        self.assetID = assetID
        self.amount = amount
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        accountID = try c.decode(String.self, forKey: .accountID)
        assetID = try c.decode(String.self, forKey: .assetID)
        amount = try c.decode(Double.self, forKey: .amount)
    }

    public init(from row: DecodedRow) throws {
        guard let accountID_ = MRebalancePurchase.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let assetID_ = MRebalancePurchase.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        amount = MRebalancePurchase.getDouble(row, CodingKeys.amount.rawValue) ?? 0
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MRebalancePurchase.getDouble(row, CodingKeys.amount.rawValue) { amount = val }
    }

    public var primaryKey: AllocKey {
        MRebalancePurchase.keyify([accountID, assetID])
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.assetID.rawValue
        guard let accountID_ = getStr(row, rawValue1),
              let assetID_ = getStr(row, rawValue2)
        else { throw AllocDataError.invalidPrimaryKey("Purchase") }
        return keyify([accountID_, assetID_])
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MRebalancePurchase.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let assetID = parseString(row[ck.assetID.rawValue]),
                  assetID.count > 0,
                  let amount = parseDouble(row[ck.amount.rawValue]),
                  amount > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            
            return [
                ck.accountID.rawValue: accountID,
                ck.assetID.rawValue: assetID,
                ck.amount.rawValue: amount,
            ]
        }
    }
}

extension MRebalancePurchase: CustomStringConvertible {
    public var description: String {
        "accountID=\(accountID) assetID=\(assetID) amount=\(String(format: "%.2f", amount))"
    }
}
