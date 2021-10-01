//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MSecurity: AllocRow {
    public init(from row: DecodedRow) throws {
        guard let securityID_ = MSecurity.getStr(row, CodingKeys.securityID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.securityID.rawValue) }
        securityID = securityID_

        assetID = MSecurity.getStr(row, CodingKeys.assetID.rawValue) ?? AllocNilKey
        sharePrice = MSecurity.getDouble(row, CodingKeys.sharePrice.rawValue)
        updatedAt = MSecurity.getDate(row, CodingKeys.updatedAt.rawValue)
        trackerID = MSecurity.getStr(row, CodingKeys.trackerID.rawValue) ?? AllocNilKey
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
