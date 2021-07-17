//
//  MRebalanceAllocation.swift
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

public struct MRebalanceAllocation: Hashable & AllocBase {
    public var accountID: String // key
    public var assetID: String // key
    public var amount: Double

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accountID = "allocationAccountID"
        case assetID = "allocationAssetID"
        case amount
    }

    public static var schema: AllocSchema { .allocRebalanceAllocation }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account to which the asset is allocated."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset class of the allocation."),
        AllocAttribute(CodingKeys.amount, .double, isRequired: true, isKey: false, "The amount in dollars allocated."),
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

    public init(from row: Row) throws {
        guard let accountID_ = MRebalanceAllocation.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let assetID_ = MRebalanceAllocation.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        amount = MRebalanceAllocation.getDouble(row, CodingKeys.amount.rawValue) ?? 0
    }

    public mutating func update(from row: Row) throws {
        if let val = MRebalanceAllocation.getDouble(row, CodingKeys.amount.rawValue) { amount = val }
    }

    public var primaryKey: AllocKey {
        MRebalanceAllocation.keyify([accountID, assetID])
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.assetID.rawValue
        guard let accountID_ = getStr(row, rawValue1),
              let assetID_ = getStr(row, rawValue2)
        else { throw AllocDataError.invalidPrimaryKey("Allocation") }
        return keyify([accountID_, assetID_])
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MRebalanceAllocation.CodingKeys.self

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

extension MRebalanceAllocation: CustomStringConvertible {
    public var description: String {
        "accountID=\(accountID) assetID=\(assetID) amount=\(String(format: "%.2f", amount))"
    }
}
