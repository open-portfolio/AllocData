//
//  M+Row.swift
//
// Copyright 2021, 2022 OpenAlloc LLC
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

extension MSourceMeta: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let _sourceMetaID = MSourceMeta.getStr(row, CodingKeys.sourceMetaID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.sourceMetaID.rawValue) }
        sourceMetaID = _sourceMetaID

        url = MSourceMeta.getURL(row, CodingKeys.url.rawValue)
        importerID = MSourceMeta.getStr(row, CodingKeys.importerID.rawValue)
        exportedAt = MSourceMeta.getDate(row, CodingKeys.exportedAt.rawValue)
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MSourceMeta.getURL(row, CodingKeys.url.rawValue) { url = val }
        if let val = MSourceMeta.getStr(row, CodingKeys.importerID.rawValue) { importerID = val }
        if let val = MSourceMeta.getDate(row, CodingKeys.exportedAt.rawValue) { exportedAt = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> Key {
        guard let _sourceMetaID = getStr(row, CodingKeys.sourceMetaID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Source Meta") }
        return Key(sourceMetaID: _sourceMetaID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MSourceMeta.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let sourceMetaID = parseString(rawRow[ck.sourceMetaID.rawValue]),
                  sourceMetaID.count > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.sourceMetaID.rawValue: sourceMetaID,
            ]

            if let url = parseURL(rawRow[ck.url.rawValue]) {
                decodedRow[ck.url.rawValue] = url
            }

            if let importerID = parseString(rawRow[ck.importerID.rawValue]) {
                decodedRow[ck.importerID.rawValue] = importerID
            }

            if let rawExportedAt = rawRow[ck.exportedAt.rawValue],
               let exportedAt = MSourceMeta.parseDate(rawExportedAt)
            {
                decodedRow[ck.exportedAt.rawValue] = exportedAt
            }

            array.append(decodedRow)
        }
    }
}
