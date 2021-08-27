//
//  MValuationHistory.swift
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

public struct MValuationHistory: Hashable & AllocBase {
    public var cashflowID: String // key
    public var transactedAt: Date // key
    public var accountID: String // key
    public var securityID: String // key
    public var lotID: String // key
    public var shareCount: Double
    public var sharePrice: Double

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case cashflowID = "valuationHistoryCashflowID"
        case transactedAt = "valuationHistoryTransactedAt"
        case accountID = "valuationHistoryAccountID"
        case securityID = "valuationHistorySecurityID"
        case lotID = "valuationHistoryLotID"
        case shareCount
        case sharePrice
    }

    public static var schema: AllocSchema { .allocValuationHistory }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.cashflowID, .string, isRequired: true, isKey: true, "The cashflow that consumed this transaction."),
        AllocAttribute(CodingKeys.transactedAt, .date, isRequired: true, isKey: true, "The timestamp when this transaction occurred."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account transacted."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security/ticker transacted."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the transacted, if any."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: true, isKey: false, "The number of shares transacted (-Sale, +Purchase)."),
        AllocAttribute(CodingKeys.sharePrice, .double, isRequired: true, isKey: false, "The price per share transacted."),
    ]

    public init(
        cashflowID: String,
        transactedAt: Date,
        accountID: String,
        securityID: String,
        lotID: String,
        shareCount: Double,
        sharePrice: Double
    ) {
        self.cashflowID = cashflowID
        self.transactedAt = transactedAt
        self.accountID = accountID
        self.securityID = securityID
        self.lotID = lotID
        self.shareCount = shareCount
        self.sharePrice = sharePrice
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        cashflowID = try c.decode(String.self, forKey: .cashflowID)
        transactedAt = try c.decode(Date.self, forKey: .transactedAt)
        accountID = try c.decode(String.self, forKey: .accountID)
        securityID = try c.decode(String.self, forKey: .securityID)
        lotID = try c.decodeIfPresent(String.self, forKey: .lotID) ?? AllocNilKey
        shareCount = try c.decode(Double.self, forKey: .shareCount)
        sharePrice = try c.decode(Double.self, forKey: .sharePrice)
    }

    public init(from row: Row) throws {
        guard let cashflowID_ = MValuationHistory.getStr(row, CodingKeys.cashflowID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.cashflowID.rawValue) }
        cashflowID = cashflowID_

        guard let transactedAt_ = MValuationHistory.getDate(row, CodingKeys.transactedAt.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.transactedAt.rawValue) }
        transactedAt = transactedAt_

        guard let accountID_ = MValuationHistory.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let securityID_ = MValuationHistory.getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.securityID.rawValue) }
        securityID = securityID_

        lotID = MValuationPosition.getStr(row, CodingKeys.lotID.rawValue) ?? AllocNilKey

        shareCount = MValuationPosition.getDouble(row, CodingKeys.shareCount.rawValue) ?? 0
        sharePrice = MValuationPosition.getDouble(row, CodingKeys.sharePrice.rawValue) ?? 0
    }

    public mutating func update(from row: Row) throws {
        if let val = MValuationPosition.getDouble(row, CodingKeys.shareCount.rawValue) { shareCount = val }
        if let val = MValuationPosition.getDouble(row, CodingKeys.sharePrice.rawValue) { sharePrice = val }
    }

    public var primaryKey: AllocKey {
        MValuationHistory.makePrimaryKey(cashflowID: cashflowID,
                                         transactedAt: transactedAt,
                                         accountID: accountID,
                                         securityID: securityID,
                                         lotID: lotID)
    }

    public static func makePrimaryKey(cashflowID: String,
                                      transactedAt: Date,
                                      accountID: String,
                                      securityID: String,
                                      lotID: String) -> AllocKey {
        
        // NOTE: using time interval in composite key as ISO dates will vary.
        // This implementation can change at ANY time and may differ per platform.
        // Because of that AllocData keys should NOT be persisted in data files
        // or across executions. If you need to store a date, use the ISO format.
        
        let refEpoch = transactedAt.timeIntervalSinceReferenceDate
        let formattedDate = String(format: "%010.0f", refEpoch)
        return keyify([cashflowID, formattedDate, accountID, securityID, lotID])
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue1 = CodingKeys.cashflowID.rawValue
        let rawValue2 = CodingKeys.transactedAt.rawValue
        let rawValue3 = CodingKeys.accountID.rawValue
        let rawValue4 = CodingKeys.securityID.rawValue
        let rawValue5 = CodingKeys.lotID.rawValue
        guard let cashflowID_ = getStr(row, rawValue1),
              let transactedAt_ = getDate(row, rawValue2),
              let accountID_ = getStr(row, rawValue3),
              let securityID_ = getStr(row, rawValue4),
              let lotID_ = getStr(row, rawValue5)
        else { throw AllocDataError.invalidPrimaryKey("Valuation History") }
        return makePrimaryKey(cashflowID: cashflowID_,
                              transactedAt: transactedAt_,
                              accountID: accountID_,
                              securityID: securityID_,
                              lotID: lotID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MValuationHistory.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let cashflowID = parseString(row[ck.cashflowID.rawValue]),
                  cashflowID.count > 0,
                  let transactedAt = parseDate(row[ck.transactedAt.rawValue]),
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
            let sharePrice = parseDouble(row[ck.sharePrice.rawValue])
        
            return [
                ck.cashflowID.rawValue: cashflowID,
                ck.transactedAt.rawValue: transactedAt,
                ck.accountID.rawValue: accountID,
                ck.securityID.rawValue: securityID,
                ck.lotID.rawValue: lotID,
                ck.shareCount.rawValue: shareCount,
                ck.sharePrice.rawValue: sharePrice,
            ]
        }
    }
}

extension MValuationHistory: CustomStringConvertible {
    public var description: String {
        let formattedDate = MValuationHistory.unparseDate(transactedAt)
        return "cashflowID=\(cashflowID) transactedAt=\(formattedDate) accountID=\(accountID) securityID=\(securityID) lotID=\(lotID) shareCount=\(shareCount) sharePrice=\(sharePrice)"
    }
}
