//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MCap: AllocRow {
    public init(from row: DecodedRow) throws {
        guard let accountID_ = MCap.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let assetID_ = MCap.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        limitPct = MCap.getDouble(row, CodingKeys.limitPct.rawValue) ?? MCap.defaultLimitPct
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MCap.getDouble(row, CodingKeys.limitPct.rawValue) { limitPct = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.assetID.rawValue
        guard let accountID_ = getStr(row, rawValue1),
              let assetID_ = getStr(row, rawValue2)
        else { throw AllocDataError.invalidPrimaryKey("Cap") }
        return keyify([accountID_, assetID_])
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MCap.CodingKeys.self

        return rawRows.compactMap { row in
            // required values
            guard let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let assetID = parseString(row[ck.assetID.rawValue]),
                  assetID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let limitPct = parseDouble(row[ck.limitPct.rawValue]) ?? MCap.defaultLimitPct

            return [
                ck.accountID.rawValue: accountID,
                ck.assetID.rawValue: assetID,
                ck.limitPct.rawValue: limitPct,
            ]
        }
    }
}
