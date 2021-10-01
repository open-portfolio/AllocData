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

extension MTracker: AllocRowed {
    public init(from row: DecodedRow) throws {
        guard let trackerID_ = MTracker.getStr(row, CodingKeys.trackerID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.trackerID.rawValue) }
        trackerID = trackerID_

        title = MTracker.getStr(row, CodingKeys.title.rawValue)
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MTracker.getStr(row, CodingKeys.title.rawValue) { title = val }
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue = CodingKeys.trackerID.rawValue
        guard let trackerID_ = getStr(row, rawValue)
        else { throw AllocDataError.invalidPrimaryKey(rawValue) }
        return keyify(trackerID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MTracker.CodingKeys.self

        return rawRows.compactMap { row in
            guard let trackerID = parseString(row[ck.trackerID.rawValue]),
                  trackerID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let title = parseString(row[ck.title.rawValue])

            return [
                ck.trackerID.rawValue: trackerID,
                ck.title.rawValue: title,
            ]
        }
    }
}
