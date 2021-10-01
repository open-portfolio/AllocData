//
//  M+Row.swift
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

extension MTransaction: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let action_ = row[CodingKeys.action.rawValue] as? MTransaction.Action
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

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue0 = CodingKeys.action.rawValue
        let rawValue1 = CodingKeys.transactedAt.rawValue
        let rawValue2 = CodingKeys.accountID.rawValue
        let rawValue3 = CodingKeys.securityID.rawValue
        let rawValue4 = CodingKeys.lotID.rawValue
        let rawValue5 = CodingKeys.shareCount.rawValue
        let rawValue6 = CodingKeys.sharePrice.rawValue
        guard let action_ = row[rawValue0] as? MTransaction.Action,
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
