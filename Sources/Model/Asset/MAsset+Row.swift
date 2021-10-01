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

extension MAsset: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let _assetID = MAsset.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = _assetID

        title = MAsset.getStr(row, CodingKeys.title.rawValue)
        colorCode = MAsset.getInt(row, CodingKeys.colorCode.rawValue)
        parentAssetID = MAsset.getStr(row, CodingKeys.parentAssetID.rawValue) ?? ""
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MAsset.getStr(row, CodingKeys.title.rawValue) { title = val }
        if let val = MAsset.getInt(row, CodingKeys.colorCode.rawValue) { colorCode = val }
        if let val = MAsset.getStr(row, CodingKeys.parentAssetID.rawValue) { parentAssetID = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        guard let _assetID = getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Asset") }
        return keyify(_assetID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MAsset.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let assetID = parseString(rawRow[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.assetID.rawValue: assetID,
            ]

            if let title = parseString(rawRow[ck.title.rawValue]) {
                decodedRow[ck.title.rawValue] = title
            }
            if let parentAssetID = parseString(rawRow[ck.parentAssetID.rawValue]) {
                decodedRow[ck.parentAssetID.rawValue] = parentAssetID
            }
            if let colorCode = parseInt(rawRow[ck.colorCode.rawValue]) {
                decodedRow[ck.colorCode.rawValue] = colorCode
            }

            array.append(decodedRow)
        }
    }
}
