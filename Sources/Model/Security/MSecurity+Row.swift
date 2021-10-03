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
        guard let _securityID = MSecurity.getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.securityID.rawValue) }
        securityID = _securityID

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
        guard let _securityID = getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Security") }
        return keyify(_securityID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MSecurity.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let securityID = parseString(rawRow[ck.securityID.rawValue]),
                  securityID.count > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.securityID.rawValue: securityID,
            ]

            if let assetID = parseString(rawRow[ck.assetID.rawValue]) {
                decodedRow[ck.assetID.rawValue] = assetID
            }
            if let sharePrice = parseDouble(rawRow[ck.sharePrice.rawValue]) {
                decodedRow[ck.sharePrice.rawValue] = sharePrice
            }
            if let trackerID = parseString(rawRow[ck.trackerID.rawValue]) {
                decodedRow[ck.trackerID.rawValue] = trackerID
            }
            if let rawUpdatedAt = rawRow[ck.updatedAt.rawValue],
               let updatedAt = MSecurity.parseDate(rawUpdatedAt)
            {
                decodedRow[ck.updatedAt.rawValue] = updatedAt
            }

            array.append(decodedRow)
        }
    }
}
