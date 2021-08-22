//
//  MHistory.swift
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

public struct MHistory: Hashable & AllocBase {
    public var transactionID: String
    public var accountID: String
    public var securityID: String
    public var lotID: String
    public var shareCount: Double?
    public var sharePrice: Double?
    public var realizedGainShort: Double?
    public var realizedGainLong: Double?
    public var transactedAt: Date? // YYYY-MM-DD date

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case transactionID
        case accountID = "historyAccountID"
        case securityID = "historySecurityID"
        case lotID = "historyLotID"
        case shareCount
        case sharePrice
        case realizedGainShort
        case realizedGainLong
        case transactedAt
    }

    public static var schema: AllocSchema { .allocHistory }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.transactionID, .string, isRequired: false, isKey: true, "Unique transaction identifier for the history record."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: false, "The account in which the transaction occurred."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: false, "The security involved in the transaction."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: false, isKey: false, "The lot of the position involved in the transaction, if any."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: false, isKey: false, "The number of shares transacted."),
        AllocAttribute(CodingKeys.sharePrice, .double, isRequired: false, isKey: false, "The price at which the share(s) transacted."),
        AllocAttribute(CodingKeys.realizedGainShort, .double, isRequired: false, isKey: false, "The total short-term realized gain (or loss) from a sale."),
        AllocAttribute(CodingKeys.realizedGainLong, .double, isRequired: false, isKey: false, "The total long-term realized gain (or loss) from a sale."),
        AllocAttribute(CodingKeys.transactedAt, .date, isRequired: false, isKey: false, "The date of the transaction."),
    ]

//    func encode(to encoder: Encoder) throws {
//        var c = encoder.container(keyedBy: CodingKeys.self)
//        try c.encode(accountID, forKey: .accountID)
//        try c.encode(securityID, forKey: .securityID)
//        try c.encode(shareCount, forKey: .shareCount)
//        try c.encode(sharePrice, forKey: .sharePrice)
//
//        // generate YYYY-MM-DD date (rather than timeIntervalSinceReferenceDate number)
//        let transactedAtStr = generateYYYYMMDD(transactedAt)
//        try c.encode(transactedAtStr, forKey: .transactedAt)
//    }

    public init(transactionID: String? = nil,
                accountID: String? = nil,
                securityID: String? = nil,
                lotID: String? = nil,
                shareCount: Double? = nil,
                sharePrice: Double? = nil,
                realizedGainShort: Double? = nil,
                realizedGainLong: Double? = nil,
                transactedAt: Date? = nil)
    {
        self.transactionID = transactionID ?? AllocNilKey
        self.accountID = accountID ?? AllocNilKey
        self.securityID = securityID ?? AllocNilKey
        self.lotID = lotID ?? AllocNilKey
        self.shareCount = shareCount
        self.sharePrice = sharePrice
        self.realizedGainShort = realizedGainShort
        self.realizedGainLong = realizedGainLong
        self.transactedAt = transactedAt
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        transactionID = try c.decodeIfPresent(String.self, forKey: .transactionID) ?? AllocNilKey
        accountID = try c.decodeIfPresent(String.self, forKey: .accountID) ?? AllocNilKey
        securityID = try c.decodeIfPresent(String.self, forKey: .securityID) ?? AllocNilKey
        lotID = try c.decodeIfPresent(String.self, forKey: .lotID) ?? AllocNilKey
        shareCount = try c.decodeIfPresent(Double.self, forKey: .shareCount)
        sharePrice = try c.decodeIfPresent(Double.self, forKey: .sharePrice)
        realizedGainShort = try c.decodeIfPresent(Double.self, forKey: .realizedGainShort)
        realizedGainLong = try c.decodeIfPresent(Double.self, forKey: .realizedGainLong)
        transactedAt = try c.decodeIfPresent(Date.self, forKey: .transactedAt)
    }

    public init(from row: Row) throws {
        guard let transactionID_ = MHistory.getStr(row, CodingKeys.transactionID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.transactionID.rawValue) }
        transactionID = transactionID_

        accountID = MHistory.getStr(row, CodingKeys.accountID.rawValue) ?? AllocNilKey
        securityID = MHistory.getStr(row, CodingKeys.securityID.rawValue) ?? AllocNilKey
        lotID = MHolding.getStr(row, CodingKeys.lotID.rawValue) ?? AllocNilKey
        shareCount = MHistory.getDouble(row, CodingKeys.shareCount.rawValue)
        sharePrice = MHistory.getDouble(row, CodingKeys.sharePrice.rawValue)
        realizedGainShort = MHistory.getDouble(row, CodingKeys.realizedGainShort.rawValue)
        realizedGainLong = MHistory.getDouble(row, CodingKeys.realizedGainLong.rawValue)
        transactedAt = MHistory.getDate(row, CodingKeys.transactedAt.rawValue)
    }

    public mutating func update(from row: Row) throws {
        // IGNORE transactionID
        if let val = MHistory.getStr(row, CodingKeys.accountID.rawValue) { accountID = val }
        if let val = MHistory.getStr(row, CodingKeys.securityID.rawValue) { securityID = val }
        if let val = MHistory.getStr(row, CodingKeys.lotID.rawValue) { lotID = val }
        if let val = MHistory.getDouble(row, CodingKeys.shareCount.rawValue) { shareCount = val }
        if let val = MHistory.getDouble(row, CodingKeys.sharePrice.rawValue) { sharePrice = val }
        if let val = MHistory.getDouble(row, CodingKeys.realizedGainShort.rawValue) { realizedGainShort = val }
        if let val = MHistory.getDouble(row, CodingKeys.realizedGainLong.rawValue) { realizedGainLong = val }
        if let val = MHistory.getDate(row, CodingKeys.transactedAt.rawValue) { transactedAt = val }
    }

    public var primaryKey: AllocKey {
        MHistory.keyify(transactionID)
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue = CodingKeys.transactionID.rawValue
        guard let transactionID_ = getStr(row, rawValue)
        else { throw AllocDataError.invalidPrimaryKey(rawValue) }
        return keyify(transactionID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows _: inout [Row]) throws -> [Row] {
        let ck = MHistory.CodingKeys.self

        return rawRows.compactMap { row in
            // required values
            // none

            // optional values
            let transactionID = parseString(row[ck.transactionID.rawValue])
            let accountID = parseString(row[ck.accountID.rawValue])
            let securityID = parseString(row[ck.securityID.rawValue])
            let lotID = parseString(row[ck.lotID.rawValue])
            let shareCount = parseDouble(row[ck.shareCount.rawValue])
            let sharePrice = parseDouble(row[ck.sharePrice.rawValue])
            let realizedGainShort = parseDouble(row[ck.realizedGainShort.rawValue])
            let realizedGainLong = parseDouble(row[ck.realizedGainLong.rawValue])
            
            let rawTransactedAt = row[ck.transactedAt.rawValue]
            let transactedAt = MHistory.parseDate(rawTransactedAt)

            return [
                ck.transactionID.rawValue: transactionID,
                ck.accountID.rawValue: accountID,
                ck.securityID.rawValue: securityID,
                ck.lotID.rawValue: lotID,
                ck.shareCount.rawValue: shareCount,
                ck.sharePrice.rawValue: sharePrice,
                ck.realizedGainShort.rawValue: realizedGainShort,
                ck.realizedGainLong.rawValue: realizedGainLong,
                ck.transactedAt.rawValue: transactedAt,
            ]
        }
    }
}

extension MHistory: CustomStringConvertible {
    public var description: String {
        "transactionID=\(transactionID) accountID=\(accountID) securityID=\(securityID) lotID=\(lotID) shareCount=\(String(describing: shareCount)) sharePrice=\(String(describing: sharePrice)) realizedGainShort=\(String(describing: realizedGainShort)) realizedGainLong=\(String(describing: realizedGainLong)) transactedAt=\(String(describing: transactedAt))"
    }
}
