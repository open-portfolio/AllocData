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
    public var cashflowID: String // key
    
    public var transactedAt: Date
    public var accountID: String
    public var assetID: String
    public var marketValue: Double

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case cashflowID = "valuationCashflowID"
        case transactedAt
        case accountID
        case assetID
        case marketValue
    }

    public static var schema: AllocSchema { .allocValuationCashflow }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.cashflowID, .string, isRequired: true, isKey: true, "The unique valuation cashflow identifier."),
        AllocAttribute(CodingKeys.transactedAt, .date, isRequired: true, isKey: false, "The timestamp when this flow occurred."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: false, "The account in which the flow occurred."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: false, "The asset class flowed."),
        AllocAttribute(CodingKeys.marketValue, .double, isRequired: true, isKey: false, "The market value of the flow (-Sale, +Purchase)."),
    ]

    public init(
        cashflowID: String,
        transactedAt: Date,
        accountID: String,
        assetID: String,
        marketValue: Double
    ) {
        self.cashflowID = cashflowID
        self.transactedAt = transactedAt
        self.accountID = accountID
        self.assetID = assetID
        self.marketValue = marketValue
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        cashflowID = try c.decode(String.self, forKey: .cashflowID)
        transactedAt = try c.decode(Date.self, forKey: .transactedAt)
        accountID = try c.decode(String.self, forKey: .accountID)
        assetID = try c.decode(String.self, forKey: .assetID)
        marketValue = try c.decode(Double.self, forKey: .marketValue)
    }

    public init(from row: Row) throws {
        guard let cashflowID_ = MValuationCashflow.getStr(row, CodingKeys.cashflowID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.cashflowID.rawValue) }
        cashflowID = cashflowID_
        
        guard let transactedAt_ = MValuationCashflow.getDate(row, CodingKeys.transactedAt.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.transactedAt.rawValue) }
        transactedAt = transactedAt_

        guard let accountID_ = MValuationCashflow.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let assetID_ = MValuationCashflow.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        marketValue = MValuationPosition.getDouble(row, CodingKeys.marketValue.rawValue) ?? 0
    }

    public mutating func update(from row: Row) throws {
        if let val = MValuationPosition.getDouble(row, CodingKeys.marketValue.rawValue) { marketValue = val }
    }

    public var primaryKey: AllocKey {
        MValuationCashflow.makePrimaryKey(cashflowID: cashflowID)
    }

    public static func makePrimaryKey(cashflowID: String) -> AllocKey {
        keyify(cashflowID)
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue0 = CodingKeys.cashflowID.rawValue
        guard let cashflowID_ = getStr(row, rawValue0)
        else { throw AllocDataError.invalidPrimaryKey("Cash Flow") }
        return makePrimaryKey(cashflowID: cashflowID_)
    }
    
    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MValuationCashflow.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let cashflowID = parseString(row[ck.cashflowID.rawValue]),
                  cashflowID.count > 0,
                  let transactedAt = parseDate(row[ck.transactedAt.rawValue]),
                  let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let assetID = parseString(row[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let marketValue = parseDouble(row[ck.marketValue.rawValue])

            return [
                ck.cashflowID.rawValue: cashflowID,
                ck.transactedAt.rawValue: transactedAt,
                ck.accountID.rawValue: accountID,
                ck.assetID.rawValue: assetID,
                ck.marketValue.rawValue: marketValue,
            ]
        }
    }
}

extension MValuationCashflow: CustomStringConvertible {
    public var description: String {
        let formattedDate = MValuationCashflow.unparseDate(transactedAt)
        return "cashflowID=\(cashflowID) transactedAt=\(formattedDate) accountID=\(accountID) assetID=\(assetID) marketValue=\(marketValue)"
    }
}
