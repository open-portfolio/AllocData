//
//  MValuationSnapshot.swift
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

public struct MValuationSnapshot: Hashable & AllocBase {
    public var snapshotID: String // key
    public var capturedAt: Date
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case snapshotID = "valuationSnapshotID"
        case capturedAt
    }

    public static var schema: AllocSchema { .allocValuationSnapshot }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.snapshotID, .string, isRequired: true, isKey: true, "The unique valuation snapshot identifier."),
        AllocAttribute(CodingKeys.capturedAt, .date, isRequired: true, isKey: false, "The timestamp when the snapshot was created."),
    ]

    public init(
        snapshotID: String,
        capturedAt: Date) {
        self.snapshotID = snapshotID
        self.capturedAt = capturedAt
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        snapshotID = try c.decode(String.self, forKey: .snapshotID)
        capturedAt = try c.decode(Date.self, forKey: .capturedAt)
    }

    public init(from row: DecodedRow) throws {
        guard let snapshotID_ = MValuationSnapshot.getStr(row, CodingKeys.snapshotID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.snapshotID.rawValue) }
        snapshotID = snapshotID_

        guard let capturedAt_ = MValuationSnapshot.getDate(row, CodingKeys.capturedAt.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.capturedAt.rawValue) }
        capturedAt = capturedAt_
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MValuationSnapshot.getDate(row, CodingKeys.capturedAt.rawValue) { capturedAt = val }
    }

    public var primaryKey: AllocKey {
        MValuationSnapshot.makePrimaryKey(snapshotID: snapshotID)
    }

    public static func makePrimaryKey(snapshotID: String) -> AllocKey {
        keyify(snapshotID)
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue0 = CodingKeys.snapshotID.rawValue
        guard let snapshotID_ = getStr(row, rawValue0)
        else { throw AllocDataError.invalidPrimaryKey("Archive") }
        return makePrimaryKey(snapshotID: snapshotID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MValuationSnapshot.CodingKeys.self

        return rawRows.compactMap { row in
            // required values, without default values
            guard let snapshotID = parseString(row[ck.snapshotID.rawValue]),
                  snapshotID.count > 0,
                  let capturedAt = parseDate(row[ck.capturedAt.rawValue])
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values

            return [
                ck.snapshotID.rawValue: snapshotID,
                ck.capturedAt.rawValue: capturedAt,
            ]
        }
    }
}

extension MValuationSnapshot: CustomStringConvertible {
    public var description: String {
        let formattedDate = MValuationSnapshot.unparseDate(capturedAt)
        return "snapshotID=\(snapshotID) capturedAt=\(formattedDate)"
    }
}
