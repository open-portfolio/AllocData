//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MRebalanceAllocation: AllocRow {
    public init(from row: DecodedRow) throws {
        guard let accountID_ = MRebalanceAllocation.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let assetID_ = MRebalanceAllocation.getStr(row, CodingKeys.assetID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.assetID.rawValue) }
        assetID = assetID_

        amount = MRebalanceAllocation.getDouble(row, CodingKeys.amount.rawValue) ?? 0
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MRebalanceAllocation.getDouble(row, CodingKeys.amount.rawValue) { amount = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue1 = CodingKeys.accountID.rawValue
        let rawValue2 = CodingKeys.assetID.rawValue
        guard let accountID_ = getStr(row, rawValue1),
              let assetID_ = getStr(row, rawValue2)
        else { throw AllocDataError.invalidPrimaryKey("Allocation") }
        return keyify([accountID_, assetID_])
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MRebalanceAllocation.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0,
                  let assetID = parseString(row[ck.assetID.rawValue]),
                  assetID.count > 0,
                  let amount = parseDouble(row[ck.amount.rawValue]),
                  amount > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values

            return [
                ck.accountID.rawValue: accountID,
                ck.assetID.rawValue: assetID,
                ck.amount.rawValue: amount,
            ]
        }
    }
}
