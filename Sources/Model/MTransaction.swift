//
//  MTransaction.swift
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

public struct MTransaction: Hashable & AllocBase {
    public var transactedAt: Date // key
    public var accountID: String // key
    public var securityID: String // key
    public var lotID: String // key
    public var shareCount: Double?
    public var sharePrice: Double?
    public var realizedGainShort: Double?
    public var realizedGainLong: Double?
    public var transactionID: String?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case transactedAt = "txnTransactedAt"
        case accountID = "txnAccountID"
        case securityID = "txnSecurityID"
        case lotID = "txnLotID"
        case shareCount
        case sharePrice
        case realizedGainShort
        case realizedGainLong
        case transactionID
    }

    public static var schema: AllocSchema { .allocTransaction }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.transactedAt, .date, isRequired: true, isKey: true, "The date of the transaction."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account in which the transaction occurred."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security involved in the transaction."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the position involved in the transaction (blank if none)."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: false, isKey: false, "The number of shares transacted."),
        AllocAttribute(CodingKeys.sharePrice, .double, isRequired: false, isKey: false, "The price at which the share(s) transacted."),
        AllocAttribute(CodingKeys.realizedGainShort, .double, isRequired: false, isKey: false, "The total short-term realized gain (or loss) from a sale."),
        AllocAttribute(CodingKeys.realizedGainLong, .double, isRequired: false, isKey: false, "The total long-term realized gain (or loss) from a sale."),
        AllocAttribute(CodingKeys.transactionID, .string, isRequired: false, isKey: false, "Unique identifier for the transaction, if any."),
    ]

    public init(transactedAt: Date? = nil,
                accountID: String? = nil,
                securityID: String? = nil,
                lotID: String? = nil,
                shareCount: Double? = nil,
                sharePrice: Double? = nil,
                realizedGainShort: Double? = nil,
                realizedGainLong: Double? = nil,
                transactionID: String? = nil)
    {
        self.transactedAt = transactedAt ?? Date()
        self.accountID = accountID ?? AllocNilKey
        self.securityID = securityID ?? AllocNilKey
        self.lotID = lotID ?? AllocNilKey
        self.shareCount = shareCount
        self.sharePrice = sharePrice
        self.realizedGainShort = realizedGainShort
        self.realizedGainLong = realizedGainLong
        self.transactionID = transactionID
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        transactedAt = try c.decodeIfPresent(Date.self, forKey: .transactedAt) ?? Date.init(timeIntervalSinceReferenceDate: 0)
        accountID = try c.decodeIfPresent(String.self, forKey: .accountID) ?? AllocNilKey
        securityID = try c.decodeIfPresent(String.self, forKey: .securityID) ?? AllocNilKey
        lotID = try c.decodeIfPresent(String.self, forKey: .lotID) ?? AllocNilKey
        shareCount = try c.decodeIfPresent(Double.self, forKey: .shareCount)
        sharePrice = try c.decodeIfPresent(Double.self, forKey: .sharePrice)
        realizedGainShort = try c.decodeIfPresent(Double.self, forKey: .realizedGainShort)
        realizedGainLong = try c.decodeIfPresent(Double.self, forKey: .realizedGainLong)
        transactionID = try c.decodeIfPresent(String.self, forKey: .transactionID)
    }

    public init(from row: Row) throws {
        guard let transactionID_ = MTransaction.getStr(row, CodingKeys.transactionID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.transactionID.rawValue) }
        transactionID = transactionID_

        transactedAt = MTransaction.getDate(row, CodingKeys.transactedAt.rawValue) ?? Date.init(timeIntervalSinceReferenceDate: 0)
        accountID = MTransaction.getStr(row, CodingKeys.accountID.rawValue) ?? AllocNilKey
        securityID = MTransaction.getStr(row, CodingKeys.securityID.rawValue) ?? AllocNilKey
        lotID = MHolding.getStr(row, CodingKeys.lotID.rawValue) ?? AllocNilKey
        shareCount = MTransaction.getDouble(row, CodingKeys.shareCount.rawValue)
        sharePrice = MTransaction.getDouble(row, CodingKeys.sharePrice.rawValue)
        realizedGainShort = MTransaction.getDouble(row, CodingKeys.realizedGainShort.rawValue)
        realizedGainLong = MTransaction.getDouble(row, CodingKeys.realizedGainLong.rawValue)
        transactionID = MTransaction.getStr(row, CodingKeys.transactionID.rawValue)
    }

    public mutating func update(from row: Row) throws {
        // ignore composite key
        if let val = MTransaction.getDouble(row, CodingKeys.shareCount.rawValue) { shareCount = val }
        if let val = MTransaction.getDouble(row, CodingKeys.sharePrice.rawValue) { sharePrice = val }
        if let val = MTransaction.getDouble(row, CodingKeys.realizedGainShort.rawValue) { realizedGainShort = val }
        if let val = MTransaction.getDouble(row, CodingKeys.realizedGainLong.rawValue) { realizedGainLong = val }
        if let val = MTransaction.getStr(row, CodingKeys.transactionID.rawValue) { transactionID = val }
    }

    public var primaryKey: AllocKey {
        MTransaction.makePrimaryKey(transactedAt: transactedAt, accountID: accountID, securityID: securityID, lotID: lotID)
    }

    public static func makePrimaryKey(transactedAt: Date, accountID: String, securityID: String, lotID: String) -> AllocKey {
        
        // NOTE: using time interval in composite key as ISO dates will vary.
        // This implementation can change at ANY time and may differ per platform.
        // Because of that AllocData keys should NOT be persisted in data files
        // or across executions. If you need to store a date, use the ISO format.
        
        let refEpoch = transactedAt.timeIntervalSinceReferenceDate
        let formattedDate = String(format: "%010.0f", refEpoch)
        return keyify([formattedDate, accountID, securityID, lotID])
    }
    
    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue0 = CodingKeys.transactedAt.rawValue
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.securityID.rawValue
        let rawValue3 = CodingKeys.lotID.rawValue
        guard let transactedAt_ = getDate(row, rawValue0),
              let accountID_ = getStr(row, rawValue1),
              let securityID_ = getStr(row, rawValue2),
              let lotID_ = getStr(row, rawValue3)
        else { throw AllocDataError.invalidPrimaryKey("Transaction") }
        return makePrimaryKey(transactedAt: transactedAt_, accountID: accountID_, securityID: securityID_, lotID: lotID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MTransaction.CodingKeys.self

        return rawRows.compactMap { row in
            // required, without default values
            guard let transactedAt = parseDate(row[ck.transactedAt.rawValue]),
                  let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let securityID = parseString(row[ck.securityID.rawValue]),
                  securityID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // required, with default value
            let lotID = parseString(row[ck.lotID.rawValue]) ?? ""

            // optional values
            let shareCount = parseDouble(row[ck.shareCount.rawValue])
            let sharePrice = parseDouble(row[ck.sharePrice.rawValue])
            let realizedGainShort = parseDouble(row[ck.realizedGainShort.rawValue])
            let realizedGainLong = parseDouble(row[ck.realizedGainLong.rawValue])
            let transactionID = parseString(row[ck.transactionID.rawValue])

            return [
                ck.transactedAt.rawValue: transactedAt,
                ck.accountID.rawValue: accountID,
                ck.securityID.rawValue: securityID,
                ck.lotID.rawValue: lotID,
                ck.shareCount.rawValue: shareCount,
                ck.sharePrice.rawValue: sharePrice,
                ck.realizedGainShort.rawValue: realizedGainShort,
                ck.realizedGainLong.rawValue: realizedGainLong,
                ck.transactionID.rawValue: transactionID,
            ]
        }
    }
}

extension MTransaction: CustomStringConvertible {
    public var description: String {
        "transactedAt=\(String(describing: transactedAt)) accountID=\(accountID) securityID=\(securityID) lotID=\(lotID) shareCount=\(String(describing: shareCount)) sharePrice=\(String(describing: sharePrice)) realizedGainShort=\(String(describing: realizedGainShort)) realizedGainLong=\(String(describing: realizedGainLong)) transactionID=\(transactionID ?? "")"
    }
}
