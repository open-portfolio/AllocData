//
//  MSale.swift
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

public struct MRebalanceSale: Hashable & AllocBase {
    public var accountID: String // key
    public var securityID: String // key
    public var lotID: String // key
    public var amount: Double
    public var shareCount: Double?
    public var liquidateAll: Bool

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case accountID = "saleAccountID"
        case securityID = "saleSecurityID"
        case lotID = "saleLotID"
        case amount
        case shareCount
        case liquidateAll
    }

    public static var schema: AllocSchema { .allocRebalanceSale }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account hosting the position."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security of the position."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the position, if any."),
        AllocAttribute(CodingKeys.amount, .double, isRequired: true, isKey: false, "The amount in dollars to liquidate from this position."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: false, isKey: false, "Estimated number of shares to liquidate from this position."),
        AllocAttribute(CodingKeys.liquidateAll, .bool, isRequired: false, isKey: false, "If true, the entire position can be liquidated."),
    ]

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

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        accountID = try c.decode(String.self, forKey: .accountID)
        securityID = try c.decode(String.self, forKey: .securityID)
        lotID = try c.decodeIfPresent(String.self, forKey: .lotID) ?? AllocNilKey
        amount = try c.decode(Double.self, forKey: .amount)
        shareCount = try c.decodeIfPresent(Double.self, forKey: .shareCount)
        liquidateAll = try c.decodeIfPresent(Bool.self, forKey: .liquidateAll) ?? false
    }

    public init(from row: DecodedRow) throws {
        guard let accountID_ = MRebalanceSale.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let securityID_ = MRebalanceSale.getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.securityID.rawValue) }
        securityID = securityID_

        lotID = MRebalanceSale.getStr(row, CodingKeys.lotID.rawValue) ?? AllocNilKey
        amount = MRebalanceSale.getDouble(row, CodingKeys.amount.rawValue) ?? 0
        shareCount = MRebalanceSale.getDouble(row, CodingKeys.shareCount.rawValue)
        liquidateAll = MRebalanceSale.getBool(row, CodingKeys.liquidateAll.rawValue) ?? false
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MRebalanceSale.getDouble(row, CodingKeys.amount.rawValue) { amount = val }
        if let val = MRebalanceSale.getDouble(row, CodingKeys.shareCount.rawValue) { shareCount = val }
        if let val = MRebalanceSale.getBool(row, CodingKeys.liquidateAll.rawValue) { liquidateAll = val }
    }

    public var primaryKey: AllocKey {
        MRebalanceSale.keyify([accountID, securityID, lotID])
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.securityID.rawValue
        let rawValue3 = CodingKeys.lotID.rawValue
        guard let accountID_ = getStr(row, rawValue1),
              let securityID_ = getStr(row, rawValue2),
              let lotID_ = getStr(row, rawValue3)
        else { throw AllocDataError.invalidPrimaryKey("Sale") }
        return keyify([accountID_, securityID_, lotID_])
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MRebalanceSale.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let securityID = parseString(row[ck.securityID.rawValue]),
                  securityID.count > 0,
                  let amount = parseDouble(row[ck.amount.rawValue]),
                  amount > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // required, but with default value
            let lotID = parseString(row[ck.lotID.rawValue]) ?? AllocNilKey

            // optional values
            let shareCount = parseDouble(row[ck.shareCount.rawValue])
            let liquidateAll = parseBool(row[ck.liquidateAll.rawValue])

            return [
                ck.accountID.rawValue: accountID,
                ck.securityID.rawValue: securityID,
                ck.lotID.rawValue: lotID,
                ck.amount.rawValue: amount,
                ck.shareCount.rawValue: shareCount,
                ck.liquidateAll.rawValue: liquidateAll,
            ]
        }
    }
}

extension MRebalanceSale: CustomStringConvertible {
    public var description: String {
        "accountID=\(accountID) securityID=\(securityID) lotID=\(lotID) amount=\(String(format: "%.2f", amount)) shareCount=\(String(describing: shareCount)) liquidateAll=\(liquidateAll)"
    }
}
