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

extension MSecurity: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let securityID_ = MSecurity.getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.securityID.rawValue) }
        securityID = securityID_

        assetID = MSecurity.getStr(row, CodingKeys.assetID.rawValue) ?? ""
        sharePrice = MSecurity.getDouble(row, CodingKeys.sharePrice.rawValue)
        updatedAt = MSecurity.getDate(row, CodingKeys.updatedAt.rawValue)
        trackerID = MSecurity.getStr(row, CodingKeys.trackerID.rawValue) ?? ""
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MSecurity.getStr(row, CodingKeys.assetID.rawValue) { assetID = val }
        if let val = MSecurity.getDouble(row, CodingKeys.sharePrice.rawValue) { sharePrice = val }
        if let val = MSecurity.getDate(row, CodingKeys.updatedAt.rawValue) { updatedAt = val }
        if let val = MSecurity.getStr(row, CodingKeys.trackerID.rawValue) { trackerID = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue = CodingKeys.securityID.rawValue
        guard let securityID_ = getStr(row, rawValue)
        else { throw AllocDataError.invalidPrimaryKey(rawValue) }
        return keyify(securityID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MSecurity.CodingKeys.self

        return rawRows.compactMap { row in
            // required values
            guard let securityID = parseString(row[ck.securityID.rawValue]),
                  securityID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let assetID = parseString(row[ck.assetID.rawValue])
            let sharePrice = parseDouble(row[ck.sharePrice.rawValue])
            let trackerID = parseString(row[ck.trackerID.rawValue])

            let rawUpdatedAt = row[ck.updatedAt.rawValue]
            let updatedAt = MSecurity.parseDate(rawUpdatedAt)

            return [
                ck.securityID.rawValue: securityID,
                ck.assetID.rawValue: assetID,
                ck.sharePrice.rawValue: sharePrice,
                ck.updatedAt.rawValue: updatedAt,
                ck.trackerID.rawValue: trackerID,
            ]
        }
    }
}
