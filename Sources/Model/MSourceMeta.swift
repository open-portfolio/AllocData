//
//  AllocProperty.swift
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

public struct MSourceMeta: Hashable & AllocBase {
    public var sourceMetaID: String // key
    public var url: URL?
    public var importerID: String?
    public var exportedAt: Date?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case sourceMetaID
        case url
        case importerID
        case exportedAt
    }

    public static var schema: AllocSchema { .allocMetaSource }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.sourceMetaID, .string, isRequired: true, isKey: true, "The unique ID of the source meta record."),
        AllocAttribute(CodingKeys.url, .string, isRequired: false, isKey: false, "The source URL, if any."),
        AllocAttribute(CodingKeys.importerID, .string, isRequired: false, isKey: false, "The id of the importer/transformer, if any."),
        AllocAttribute(CodingKeys.exportedAt, .date, isRequired: false, isKey: false, "The published export date of the source data, if any."),
    ]

    public init(sourceMetaID: String,
                url: URL? = nil,
                importerID: String? = nil,
                exportedAt: Date? = nil)
    {
        self.sourceMetaID = sourceMetaID
        self.url = url
        self.importerID = importerID
        self.exportedAt = exportedAt
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        sourceMetaID = try c.decode(String.self, forKey: .sourceMetaID)
        url = try c.decodeIfPresent(URL.self, forKey: .url)
        importerID = try c.decodeIfPresent(String.self, forKey: .importerID)
        exportedAt = try c.decodeIfPresent(Date.self, forKey: .exportedAt)
    }

    public init(from row: Row) throws {
        guard let sourceMetaID_ = MSourceMeta.getStr(row, CodingKeys.sourceMetaID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.sourceMetaID.rawValue) }
        sourceMetaID = sourceMetaID_

        url = MSourceMeta.getURL(row, CodingKeys.url.rawValue)
        importerID = MSourceMeta.getStr(row, CodingKeys.importerID.rawValue)
        exportedAt = MSourceMeta.getDate(row, CodingKeys.exportedAt.rawValue)
    }

    public mutating func update(from row: Row) throws {
        if let val = MSourceMeta.getURL(row, CodingKeys.url.rawValue) { url = val }
        if let val = MSourceMeta.getStr(row, CodingKeys.importerID.rawValue) { importerID = val }
        if let val = MSourceMeta.getDate(row, CodingKeys.exportedAt.rawValue) { exportedAt = val }
    }

    public var primaryKey: AllocKey {
        MSourceMeta.keyify(sourceMetaID)
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue = CodingKeys.sourceMetaID.rawValue
        guard let sourceMetaID_ = getStr(row, rawValue)
        else { throw AllocDataError.invalidPrimaryKey(rawValue) }
        return keyify(sourceMetaID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
        let ck = MSourceMeta.CodingKeys.self

        return rawRows.compactMap { row in
            guard let sourceMetaID = parseString(row[ck.sourceMetaID.rawValue]),
                  sourceMetaID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let url = parseURL(row[ck.url.rawValue])
            let importerID = parseString(row[ck.importerID.rawValue])
            
            let rawExportedAt = row[ck.exportedAt.rawValue]
            let exportedAt = MSourceMeta.parseDate(rawExportedAt)


            return [
                ck.sourceMetaID.rawValue: sourceMetaID,
                ck.url.rawValue: url,
                ck.importerID.rawValue: importerID,
                ck.exportedAt.rawValue: exportedAt,
            ]
        }
    }
}

extension MSourceMeta: CustomStringConvertible {
    public var description: String {
        "sourceMetaID=\(sourceMetaID) url=\(String(describing: url)) importerID=\(String(describing: importerID)) exportedAt=\(String(describing: exportedAt))"
    }
}
