//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MValuationPosition: AllocRow {
    public init(from row: DecodedRow) throws {
        guard let snapshotID_ = MValuationPosition.getStr(row, CodingKeys.snapshotID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.snapshotID.rawValue) }
        snapshotID = snapshotID_

        guard let accountID_ = MValuationPosition.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let assetID_ = MValuationPosition.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        totalBasis = MValuationPosition.getDouble(row, CodingKeys.totalBasis.rawValue) ?? 0
        marketValue = MValuationPosition.getDouble(row, CodingKeys.marketValue.rawValue) ?? 0
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MValuationPosition.getDouble(row, CodingKeys.totalBasis.rawValue) { totalBasis = val }
        if let val = MValuationPosition.getDouble(row, CodingKeys.marketValue.rawValue) { marketValue = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue0 = CodingKeys.snapshotID.rawValue
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.assetID.rawValue
        guard let snapshotID_ = getStr(row, rawValue0),
              let accountID_ = getStr(row, rawValue1),
              let assetID_ = getStr(row, rawValue2)
        else { throw AllocDataError.invalidPrimaryKey("Position") }
        return makePrimaryKey(snapshotID: snapshotID_, accountID: accountID_, assetID: assetID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MValuationPosition.CodingKeys.self

        return rawRows.compactMap { rawRow in
            // required values, without default values
            guard let snapshotID = parseString(rawRow[ck.snapshotID.rawValue]),
                  let accountID = parseString(rawRow[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let assetID = parseString(rawRow[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(rawRow)
                return nil
            }

            // optional values
            let totalBasis = parseDouble(rawRow[ck.totalBasis.rawValue])
            let marketValue = parseDouble(rawRow[ck.marketValue.rawValue])

            return [
                ck.snapshotID.rawValue: snapshotID,
                ck.accountID.rawValue: accountID,
                ck.assetID.rawValue: assetID,
                ck.totalBasis.rawValue: totalBasis,
                ck.marketValue.rawValue: marketValue,
            ]
        }
    }
}
