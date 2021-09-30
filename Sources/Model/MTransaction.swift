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
    public var action: Action // key
    public var transactedAt: Date // key
    public var accountID: String // key
    public var securityID: String // key
    public var lotID: String // key
    public var shareCount: Double // key
    public var sharePrice: Double // key
    public var realizedGainShort: Double?
    public var realizedGainLong: Double?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case action = "txnAction"
        case transactedAt = "txnTransactedAt"
        case accountID = "txnAccountID"
        case securityID = "txnSecurityID"
        case lotID = "txnLotID"
        case shareCount = "txnShareCount"
        case sharePrice = "txnSharePrice"
        case realizedGainShort
        case realizedGainLong
    }

    public static var schema: AllocSchema { .allocTransaction }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.action, .string, isRequired: true, isKey: true, "The type of transaction."),
        AllocAttribute(CodingKeys.transactedAt, .date, isRequired: true, isKey: true, "The date of the transaction."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account in which the transaction occurred."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security involved in the transaction."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the position involved in the transaction (blank if none)."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: true, isKey: true, "The number of shares transacted."),
        AllocAttribute(CodingKeys.sharePrice, .double, isRequired: true, isKey: true, "The price at which the share(s) transacted."),
        AllocAttribute(CodingKeys.realizedGainShort, .double, isRequired: false, isKey: false, "The total short-term realized gain (or loss) from a sale."),
        AllocAttribute(CodingKeys.realizedGainLong, .double, isRequired: false, isKey: false, "The total long-term realized gain (or loss) from a sale."),
    ]

    public init(action: Action,
                transactedAt: Date,
                accountID: String,
                securityID: String,
                lotID: String = AllocNilKey,
                shareCount: Double = 0,
                sharePrice: Double = 0,
                realizedGainShort: Double? = nil,
                realizedGainLong: Double? = nil)
    {
        self.action = action
        self.transactedAt = transactedAt
        self.accountID = accountID
        self.securityID = securityID
        self.lotID = lotID
        self.shareCount = shareCount
        self.sharePrice = sharePrice
        self.realizedGainShort = realizedGainShort
        self.realizedGainLong = realizedGainLong
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        action = try c.decode(Action.self, forKey: .action)
        transactedAt = try c.decodeIfPresent(Date.self, forKey: .transactedAt) ?? Date.init(timeIntervalSinceReferenceDate: 0)
        accountID = try c.decodeIfPresent(String.self, forKey: .accountID) ?? AllocNilKey
        securityID = try c.decodeIfPresent(String.self, forKey: .securityID) ?? AllocNilKey
        lotID = try c.decodeIfPresent(String.self, forKey: .lotID) ?? AllocNilKey
        shareCount = try c.decodeIfPresent(Double.self, forKey: .shareCount) ?? 0
        sharePrice = try c.decodeIfPresent(Double.self, forKey: .sharePrice) ?? 0
        realizedGainShort = try c.decodeIfPresent(Double.self, forKey: .realizedGainShort)
        realizedGainLong = try c.decodeIfPresent(Double.self, forKey: .realizedGainLong)
    }

    public init(from row: DecodedRow) throws {
        guard let rawAction = MTransaction.getStr(row, CodingKeys.action.rawValue),
              let action_ = Action(rawValue: rawAction)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.action.rawValue) }
        action = action_

        guard let transactedAt_ = MTransaction.getDate(row, CodingKeys.transactedAt.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.transactedAt.rawValue) }
        transactedAt = transactedAt_

        accountID = MTransaction.getStr(row, CodingKeys.accountID.rawValue) ?? AllocNilKey
        securityID = MTransaction.getStr(row, CodingKeys.securityID.rawValue) ?? AllocNilKey
        lotID = MTransaction.getStr(row, CodingKeys.lotID.rawValue) ?? AllocNilKey
        
        shareCount = MTransaction.getDouble(row, CodingKeys.shareCount.rawValue) ?? 0
        sharePrice = MTransaction.getDouble(row, CodingKeys.sharePrice.rawValue) ?? 0

        realizedGainShort = MTransaction.getDouble(row, CodingKeys.realizedGainShort.rawValue)
        realizedGainLong = MTransaction.getDouble(row, CodingKeys.realizedGainLong.rawValue)
    }

    public mutating func update(from row: DecodedRow) throws {
        // ignore composite key
        if let val = MTransaction.getDouble(row, CodingKeys.realizedGainShort.rawValue) { realizedGainShort = val }
        if let val = MTransaction.getDouble(row, CodingKeys.realizedGainLong.rawValue) { realizedGainLong = val }
    }

    public var primaryKey: AllocKey {
        MTransaction.makePrimaryKey(action: action,
                                    transactedAt: transactedAt,
                                    accountID: accountID,
                                    securityID: securityID,
                                    lotID: lotID,
                                    shareCount: shareCount,
                                    sharePrice: sharePrice)
    }

    public static func makePrimaryKey(action: Action,
                                      transactedAt: Date,
                                      accountID: String,
                                      securityID: String,
                                      lotID: String,
                                      shareCount: Double,
                                      sharePrice: Double) -> AllocKey {
        
        // NOTE: using time interval in composite key as ISO dates will vary.
        
        // This implementation can change at ANY time and may differ per platform.
        // Because of that AllocData keys should NOT be persisted in data files
        // or across executions. If you need to store a date, use the ISO format.
        
        let formattedAction = action.rawValue
        let refEpoch = transactedAt.timeIntervalSinceReferenceDate
        let formattedDate = String(format: "%010.0f", refEpoch)
        let formattedShareCount = String(format: "%.4f", shareCount)
        let formattedSharePrice = String(format: "%.4f", sharePrice)
        return keyify([formattedAction, formattedDate, accountID, securityID, lotID, formattedShareCount, formattedSharePrice])
    }
    
    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue0 = CodingKeys.action.rawValue
        let rawValue1 = CodingKeys.transactedAt.rawValue
        let rawValue2 = CodingKeys.accountID.rawValue
        let rawValue3 = CodingKeys.securityID.rawValue
        let rawValue4 = CodingKeys.lotID.rawValue
        let rawValue5 = CodingKeys.shareCount.rawValue
        let rawValue6 = CodingKeys.sharePrice.rawValue
        guard let rawAction = getStr(row, rawValue0),
              let action_ = Action(rawValue: rawAction),
              let transactedAt_ = getDate(row, rawValue1),
              case let accountID_ = getStr(row, rawValue2) ?? AllocNilKey,
              case let securityID_ = getStr(row, rawValue3) ?? AllocNilKey,
              case let lotID_ = getStr(row, rawValue4) ?? AllocNilKey,
              let shareCount_ = getDouble(row, rawValue5),
              let sharePrice_ = getDouble(row, rawValue6)
        else { throw AllocDataError.invalidPrimaryKey("Transaction") }
        return makePrimaryKey(action: action_,
                              transactedAt: transactedAt_,
                              accountID: accountID_,
                              securityID: securityID_,
                              lotID: lotID_,
                              shareCount: shareCount_,
                              sharePrice: sharePrice_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MTransaction.CodingKeys.self

        return rawRows.compactMap { row in
            // required, without default values
            guard let rawAction = parseString(row[ck.action.rawValue]),
                  let action = Action(rawValue: rawAction),
                  let transactedAt = parseDate(row[ck.transactedAt.rawValue])
            else {
                rejectedRows.append(row)
                return nil
            }

            // required, with default value
            let accountID = parseString(row[ck.accountID.rawValue]) ?? AllocNilKey
            let securityID = parseString(row[ck.securityID.rawValue]) ?? AllocNilKey
            let lotID = parseString(row[ck.lotID.rawValue]) ?? AllocNilKey
            let shareCount = parseDouble(row[ck.shareCount.rawValue]) ?? 0
            let sharePrice = parseDouble(row[ck.sharePrice.rawValue]) ?? 0

            // optional values
            let realizedGainShort = parseDouble(row[ck.realizedGainShort.rawValue])
            let realizedGainLong = parseDouble(row[ck.realizedGainLong.rawValue])

            return [
                ck.action.rawValue: action,
                ck.transactedAt.rawValue: transactedAt,
                ck.accountID.rawValue: accountID,
                ck.securityID.rawValue: securityID,
                ck.lotID.rawValue: lotID,
                ck.shareCount.rawValue: shareCount,
                ck.sharePrice.rawValue: sharePrice,
                ck.realizedGainShort.rawValue: realizedGainShort,
                ck.realizedGainLong.rawValue: realizedGainLong,
            ]
        }
    }
}

extension MTransaction: CustomStringConvertible {
    public var description: String {
        "action=\(action) transactedAt=\(String(describing: transactedAt)) accountID=\(accountID) securityID=\(securityID) lotID=\(lotID) shareCount=\(String(describing: shareCount)) sharePrice=\(String(describing: sharePrice)) realizedGainShort=\(String(describing: realizedGainShort)) realizedGainLong=\(String(describing: realizedGainLong))"
    }
}
