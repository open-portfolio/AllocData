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

extension MValuationSnapshot: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let _snapshotID = MValuationSnapshot.getStr(row, CodingKeys.snapshotID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.snapshotID.rawValue) }
        snapshotID = _snapshotID

        guard let _capturedAt = MValuationSnapshot.getDate(row, CodingKeys.capturedAt.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.capturedAt.rawValue) }
        capturedAt = _capturedAt
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MValuationSnapshot.getDate(row, CodingKeys.capturedAt.rawValue) { capturedAt = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> Key {
        guard let _snapshotID = getStr(row, CodingKeys.snapshotID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Valuation Snapshot") }
        // return makePrimaryKey(snapshotID: _snapshotID)
        return Key(snapshotID: _snapshotID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MValuationSnapshot.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let snapshotID = parseString(rawRow[ck.snapshotID.rawValue]),
                  snapshotID.count > 0,
                  let capturedAt = parseDate(rawRow[ck.capturedAt.rawValue])
            else {
                rejectedRows.append(rawRow)
                return
            }

            let decodedRow: DecodedRow = [
                ck.snapshotID.rawValue: snapshotID,
                ck.capturedAt.rawValue: capturedAt,
            ]

            array.append(decodedRow)
        }
    }
}
