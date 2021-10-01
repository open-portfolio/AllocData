//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MValuationAccount: AllocRow {
    public init(from row: DecodedRow) throws {
        guard let snapshotID_ = MValuationAccount.getStr(row, CodingKeys.snapshotID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.snapshotID.rawValue) }
        snapshotID = snapshotID_

        guard let accountID_ = MValuationAccount.getStr(row, CodingKeys.accountID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.accountID.rawValue) }
        accountID = accountID_

        guard let strategyID_ = MValuationAccount.getStr(row, CodingKeys.strategyID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.strategyID.rawValue) }
        strategyID = strategyID_

        strategyID = MValuationAccount.getStr(row, CodingKeys.strategyID.rawValue) ?? AllocNilKey
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MValuationPosition.getStr(row, CodingKeys.strategyID.rawValue) { strategyID = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue0 = CodingKeys.snapshotID.rawValue
        let rawValue1 = CodingKeys.accountID.rawValue
        guard let snapshotID_ = getStr(row, rawValue0),
              let accountID_ = getStr(row, rawValue1)
        else { throw AllocDataError.invalidPrimaryKey("Valuation Account") }
        return makePrimaryKey(snapshotID: snapshotID_, accountID: accountID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MValuationAccount.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let snapshotID = parseString(row[ck.snapshotID.rawValue]),
                  let accountID = parseString(row[ck.accountID.rawValue]),
                  accountID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let strategyID = parseString(row[ck.strategyID.rawValue]) ?? AllocNilKey

            return [
                ck.snapshotID.rawValue: snapshotID,
                ck.accountID.rawValue: accountID,
                ck.strategyID.rawValue: strategyID,
            ]
        }
    }
}
