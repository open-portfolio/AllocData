//
//  MValuationCashflow.swift
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

public struct MValuationCashflow: Hashable & AllocBase {
    public var transactedAt: Date // key
    public var accountID: String // key
    public var assetID: String // key

    public var amount: Double

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case transactedAt = "valuationCashflowTransactedAt"
        case accountID = "valuationCashflowAccountID"
        case assetID = "valuationCashflowAssetID"
        case amount
    }

    public static var schema: AllocSchema { .allocValuationCashflow }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.transactedAt, .date, isRequired: true, isKey: true, "The timestamp when this flow occurred."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account in which the flow occurred."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset class flowed."),
        AllocAttribute(CodingKeys.amount, .double, isRequired: true, isKey: false, "The amount of the flow (-Sale, +Purchase)."),
    ]

    public init(
        transactedAt: Date,
        accountID: String,
        assetID: String,
        amount: Double = 0
    ) {
        self.transactedAt = transactedAt
        self.accountID = accountID
        self.assetID = assetID
        self.amount = amount
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        transactedAt = try c.decode(Date.self, forKey: .transactedAt)
        accountID = try c.decode(String.self, forKey: .accountID)
        assetID = try c.decode(String.self, forKey: .assetID)
        amount = try c.decode(Double.self, forKey: .amount)
    }

    public init(from row: Row) throws {
        guard let transactedAt_ = MValuationCashflow.getDate(row, CodingKeys.transactedAt.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.transactedAt.rawValue) }
        transactedAt = transactedAt_

        guard let accountID_ = MValuationCashflow.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let assetID_ = MValuationCashflow.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        amount = MValuationPosition.getDouble(row, CodingKeys.amount.rawValue) ?? 0
    }

    public mutating func update(from row: Row) throws {
        if let val = MValuationPosition.getDouble(row, CodingKeys.amount.rawValue) { amount = val }
    }

    public var primaryKey: AllocKey {
        MValuationCashflow.makePrimaryKey(transactedAt: transactedAt, accountID: accountID, assetID: assetID)
    }

    public static func makePrimaryKey(transactedAt: Date, accountID: String, assetID: String) -> AllocKey {
        
        // NOTE: using time interval in composite key as ISO dates will vary.
        // This implementation can change at ANY time and may differ per platform.
        // Because of that AllocData keys should NOT be persisted in data files
        // or across executions. If you need to store a date, use the ISO format.
        
        let refEpoch = transactedAt.timeIntervalSinceReferenceDate
        let formattedDate = String(format: "%010.0f", refEpoch)
        return keyify([formattedDate, accountID, assetID])
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue0 = CodingKeys.transactedAt.rawValue
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.assetID.rawValue
        guard let transactedAt_ = getDate(row, rawValue0),
              let accountID_ = getStr(row, rawValue1),
              let assetID_ = getStr(row, rawValue2)
        else { throw AllocDataError.invalidPrimaryKey("Position") }
        return makePrimaryKey(transactedAt: transactedAt_, accountID: accountID_, assetID: assetID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MValuationCashflow.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let transactedAt = parseDate(row[ck.transactedAt.rawValue]),
                  let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let assetID = parseString(row[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let amount = parseDouble(row[ck.amount.rawValue])

            return [
                ck.transactedAt.rawValue: transactedAt,
                ck.accountID.rawValue: accountID,
                ck.assetID.rawValue: assetID,
                ck.amount.rawValue: amount,
            ]
        }
    }
}

extension MValuationCashflow: CustomStringConvertible {
    public var description: String {
        let formattedDate = MValuationSnapshot.unparseDate(transactedAt)
        return "transactedAt=\(formattedDate) accountID=\(accountID) assetID=\(assetID) amount=\(amount)"
    }
}
