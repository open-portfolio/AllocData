//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MSourceMeta: AllocRow {
    public init(from row: DecodedRow) throws {
        guard let sourceMetaID_ = MSourceMeta.getStr(row, CodingKeys.sourceMetaID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.sourceMetaID.rawValue) }
        sourceMetaID = sourceMetaID_

        url = MSourceMeta.getURL(row, CodingKeys.url.rawValue)
        importerID = MSourceMeta.getStr(row, CodingKeys.importerID.rawValue)
        exportedAt = MSourceMeta.getDate(row, CodingKeys.exportedAt.rawValue)
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MSourceMeta.getURL(row, CodingKeys.url.rawValue) { url = val }
        if let val = MSourceMeta.getStr(row, CodingKeys.importerID.rawValue) { importerID = val }
        if let val = MSourceMeta.getDate(row, CodingKeys.exportedAt.rawValue) { exportedAt = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue = CodingKeys.sourceMetaID.rawValue
        guard let sourceMetaID_ = getStr(row, rawValue)
        else { throw AllocDataError.invalidPrimaryKey(rawValue) }
        return keyify(sourceMetaID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
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
