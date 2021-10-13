//
//  M+Row.swift
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

extension MStrategy: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let _strategyID = MStrategy.getStr(row, CodingKeys.strategyID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.strategyID.rawValue) }
        strategyID = _strategyID

        title = MStrategy.getStr(row, CodingKeys.title.rawValue)
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MStrategy.getStr(row, CodingKeys.title.rawValue) { title = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> Key {
        guard let _strategyID = getStr(row, CodingKeys.strategyID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey("Strategy") }
        return Key(strategyID: _strategyID)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MStrategy.CodingKeys.self

        return rawRows.reduce(into: []) { array, rawRow in
            guard let strategyID = parseString(rawRow[ck.strategyID.rawValue]),
                  strategyID.count > 0
            else {
                rejectedRows.append(rawRow)
                return
            }

            var decodedRow: DecodedRow = [
                ck.strategyID.rawValue: strategyID,
            ]

            if let title = parseString(rawRow[ck.title.rawValue]) {
                decodedRow[ck.title.rawValue] = title
            }

            array.append(decodedRow)
        }
    }
}
