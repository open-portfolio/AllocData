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

extension MHolding: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let accountID_ = MHolding.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let securityID_ = MHolding.getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.securityID.rawValue) }
        securityID = securityID_

        lotID = MHolding.getStr(row, CodingKeys.lotID.rawValue) ?? ""
        shareCount = MHolding.getDouble(row, CodingKeys.shareCount.rawValue)
        shareBasis = MHolding.getDouble(row, CodingKeys.shareBasis.rawValue)
        acquiredAt = MHolding.getDate(row, CodingKeys.acquiredAt.rawValue)
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MHolding.getDouble(row, CodingKeys.shareCount.rawValue) { shareCount = val }
        if let val = MHolding.getDouble(row, CodingKeys.shareBasis.rawValue) { shareBasis = val }
        if let val = MHolding.getDate(row, CodingKeys.acquiredAt.rawValue) { acquiredAt = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.securityID.rawValue
        let rawValue3 = CodingKeys.lotID.rawValue
        guard let accountID_ = getStr(row, rawValue1),
              let securityID_ = getStr(row, rawValue2),
              let lotID_ = getStr(row, rawValue3)
        else { throw AllocDataError.invalidPrimaryKey("Holding") }
        return keyify([accountID_, securityID_, lotID_])
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MHolding.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let accountID = parseString(rawRow[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let securityID = parseString(rawRow[ck.securityID.rawValue]),
                  securityID.count > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.accountID.rawValue: accountID,
                ck.securityID.rawValue: securityID,
            ]

            if let lotID = parseString(rawRow[ck.lotID.rawValue]) {
                decodedRow[ck.lotID.rawValue] = lotID
            }

            if let shareCount = parseDouble(rawRow[ck.shareCount.rawValue]) {
                decodedRow[ck.shareCount.rawValue] = shareCount
            }

            if let shareBasis = parseDouble(rawRow[ck.shareBasis.rawValue]) {
                decodedRow[ck.shareBasis.rawValue] = shareBasis
            }

            if let rawAcquiredAt = rawRow[ck.acquiredAt.rawValue],
               let acquiredAt = MHolding.parseDate(rawAcquiredAt)
            {
                decodedRow[ck.acquiredAt.rawValue] = acquiredAt
            }

            array.append(decodedRow)
        }
    }
}
