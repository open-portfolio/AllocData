//
//  MValuationAccount.swift
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

public struct MValuationAccount: Hashable & AllocBase {
    public var snapshotID: String // key
    public var accountID: String // key
    
    public var strategyID: String

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case snapshotID = "valuationAccountSnapshotID"
        case accountID = "valuationAccountAccountID"
        case strategyID = "strategyID"
    }

    public static var schema: AllocSchema { .allocValuationAccount }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.snapshotID, .string, isRequired: true, isKey: true, "The valuation snapshot ID for the account."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account identifier"),
        AllocAttribute(CodingKeys.strategyID, .string, isRequired: true, isKey: false, "The strategy assignment for the account at the time."),
    ]

    public init(
        snapshotID: String,
        accountID: String,
        strategyID: String = AllocNilKey
    ) {
        self.snapshotID = snapshotID
        self.accountID = accountID
        self.strategyID = strategyID
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        snapshotID = try c.decode(String.self, forKey: .snapshotID)
        accountID = try c.decode(String.self, forKey: .accountID)
        strategyID = try c.decodeIfPresent(String.self, forKey: .strategyID) ?? AllocNilKey
    }

    public init(from row: Row) throws {
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

    public mutating func update(from row: Row) throws {
        if let val = MValuationPosition.getStr(row, CodingKeys.strategyID.rawValue) { strategyID = val }
    }

    public var primaryKey: AllocKey {
        MValuationAccount.makePrimaryKey(snapshotID: snapshotID, accountID: accountID)
    }

    public static func makePrimaryKey(snapshotID: String, accountID: String) -> AllocKey {
        keyify([snapshotID, accountID])
    }

    public static func getPrimaryKey(_ row: Row) throws -> AllocKey {
        let rawValue0 = CodingKeys.snapshotID.rawValue
        let rawValue1 = CodingKeys.accountID.rawValue
        guard let snapshotID_ = getStr(row, rawValue0),
              let accountID_ = getStr(row, rawValue1)
        else { throw AllocDataError.invalidPrimaryKey("Valuation Account") }
        return makePrimaryKey(snapshotID: snapshotID_, accountID: accountID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row] {
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

extension MValuationAccount: CustomStringConvertible {
    public var description: String {
       "snapshotID=\(snapshotID) accountID=\(accountID) strategyID=\(strategyID)"
    }
}
