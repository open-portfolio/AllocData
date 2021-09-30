//
//  AllocTracker.swift
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

public struct MTracker: Hashable & AllocBase {
    public var trackerID: String // key
    public var title: String?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case trackerID
        case title
    }

    public static var schema: AllocSchema { .allocTracker }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.trackerID, .string, isRequired: true, isKey: true, "The name of the tracking index."),
        AllocAttribute(CodingKeys.title, .string, isRequired: false, isKey: false, "The title of the tracking index."),
    ]

    public init(trackerID: String,
                title: String? = nil)
    {
        self.trackerID = trackerID
        self.title = title
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        trackerID = try c.decode(String.self, forKey: .trackerID)
        title = try c.decodeIfPresent(String.self, forKey: .title)
    }

    public init(from row: DecodedRow) throws {
        guard let trackerID_ = MTracker.getStr(row, CodingKeys.trackerID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.trackerID.rawValue) }
        trackerID = trackerID_

        title = MTracker.getStr(row, CodingKeys.title.rawValue)
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MTracker.getStr(row, CodingKeys.title.rawValue) { title = val }
    }

    public var primaryKey: AllocKey {
        MTracker.keyify(trackerID)
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

extension MTracker: CustomStringConvertible {
    public var description: String {
        "trackerID=\(trackerID) title=\(String(describing: title))"
    }
}
