//
//  MAsset.swift
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

public struct MAsset: Hashable & AllocBase {
    public var assetID: String // key
    public var title: String?
    public var colorCode: Int?
    public var parentAssetID: String

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case assetID
        case title
        case colorCode
        case parentAssetID
    }

    public static var schema: AllocSchema { .allocAsset }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The id of the asset."),
        AllocAttribute(CodingKeys.title, .string, isRequired: false, isKey: false, "The title of the asset."),
        AllocAttribute(CodingKeys.colorCode, .int, isRequired: false, isKey: false, "The code for the asset's color palette."),
        AllocAttribute(CodingKeys.parentAssetID, .string, isRequired: false, isKey: false, "The id of the parent of the asset."),
    ]

    public init(assetID: String,
                title: String? = nil,
                colorCode: Int? = nil,
                parentAssetID: String? = nil)
    {
        self.assetID = assetID
        self.title = title
        self.colorCode = colorCode
        self.parentAssetID = parentAssetID ?? AllocNilKey
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        assetID = try c.decode(String.self, forKey: .assetID)
        title = try c.decodeIfPresent(String.self, forKey: .title)
        colorCode = try c.decodeIfPresent(Int.self, forKey: .colorCode)
        parentAssetID = try c.decodeIfPresent(String.self, forKey: .parentAssetID) ?? AllocNilKey
    }

    public init(from row: Row) throws {
        guard let assetID_ = MAsset.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        title = MAsset.getStr(row, CodingKeys.title.rawValue)
        colorCode = MAsset.getInt(row, CodingKeys.colorCode.rawValue)
        parentAssetID = MAsset.getStr(row, CodingKeys.parentAssetID.rawValue) ?? AllocNilKey
    }

    public mutating func update(from row: Row) throws {
        if let val = MAsset.getStr(row, CodingKeys.title.rawValue) { title = val }
        if let val = MAsset.getInt(row, CodingKeys.colorCode.rawValue) { colorCode = val }
        if let val = MAsset.getStr(row, CodingKeys.parentAssetID.rawValue) { parentAssetID = val }
    }

    public var primaryKey: AllocKey {
        MAsset.keyify(assetID)
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue = CodingKeys.assetID.rawValue
        guard let assetID_ = getStr(row, rawValue)
        else { throw AllocDataError.invalidPrimaryKey(rawValue) }
        return keyify(assetID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MAsset.CodingKeys.self

        return rawRows.compactMap { row in
            // required values
            guard let assetID = parseString(row[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let title = parseString(row[ck.title.rawValue])
            let parentAssetID = parseString(row[ck.parentAssetID.rawValue])
            let colorCode = parseInt(row[ck.colorCode.rawValue])

            return [
                ck.assetID.rawValue: assetID,
                ck.title.rawValue: title,
                ck.colorCode.rawValue: colorCode,
                ck.parentAssetID.rawValue: parentAssetID,
            ]
        }
    }
}

extension MAsset: CustomStringConvertible {
    public var description: String {
        "assetID=\(assetID) title=\(String(describing: title)) colorCode=\(String(describing: colorCode)) parentAssetID=\(parentAssetID)"
    }
}
