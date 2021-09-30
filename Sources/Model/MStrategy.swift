//
//  AllocStrategy.swift
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

public struct MStrategy: Hashable & AllocBase {
    public var strategyID: String // key
    public var title: String?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case strategyID
        case title
    }

    public static var schema: AllocSchema { .allocStrategy }

    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.strategyID, .string, isRequired: true, isKey: true, "The name of the strategy."),
        AllocAttribute(CodingKeys.title, .string, isRequired: false, isKey: false, "The title of the strategy."),
    ]

    public init(strategyID: String,
                title: String? = nil)
    {
        self.strategyID = strategyID
        self.title = title
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        strategyID = try c.decode(String.self, forKey: .strategyID)
        title = try c.decodeIfPresent(String.self, forKey: .title)
    }

    public init(from row: DecodedRow) throws {
        guard let strategyID_ = MStrategy.getStr(row, CodingKeys.strategyID.rawValue)
        else { throw AllocDataError.invalidPrimaryKey(CodingKeys.strategyID.rawValue) }
        strategyID = strategyID_

        title = MStrategy.getStr(row, CodingKeys.title.rawValue)
    }

    public mutating func update(from row: DecodedRow) throws {
        if let val = MStrategy.getStr(row, CodingKeys.title.rawValue) { title = val }
    }

    public var primaryKey: AllocKey {
        MStrategy.keyify(strategyID)
    }

    public static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey {
        let rawValue = CodingKeys.strategyID.rawValue
        guard let strategyID_ = getStr(row, rawValue)
        else { throw AllocDataError.invalidPrimaryKey(rawValue) }
        return keyify(strategyID_)
    }

    public static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow] {
        let ck = MStrategy.CodingKeys.self

        return rawRows.compactMap { row in
            guard let strategyID = parseString(row[ck.strategyID.rawValue]),
                  strategyID.count > 0
            else {
                rejectedRows.append(row)
                return nil
            }

            // optional values
            let title = parseString(row[ck.title.rawValue])

            return [
                ck.strategyID.rawValue: strategyID,
                ck.title.rawValue: title,
            ]
        }
    }
}

extension MStrategy: CustomStringConvertible {
    public var description: String {
        "strategyID=\(strategyID) title=\(String(describing: title))"
    }
}
