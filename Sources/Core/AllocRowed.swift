//
//  AllocRowed.swift
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

public protocol AllocRowed: AllocKeyed {
    // pre-decoded row, without strong typing
    typealias RawRow = [String: String]

    // decoded row, with stronger typing
    typealias DecodedRow = [String: AnyHashable]

    // create object from row
    init(from row: DecodedRow) throws

    static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow]

    // additive update from row
    mutating func update(from row: DecodedRow) throws

    static func getPrimaryKey(_ row: DecodedRow) throws -> Key
}

public extension AllocRowed {
    static func getStr(_ row: DecodedRow, _ key: String) -> String? {
        if let val = row[key] as? String {
            return val
        }

        // note that value may be a slice, in which case it does NOT cast as string
        if let val = row[key] as? Substring {
            return String(val)
        }

        return nil
    }

    static func getBool(_ row: DecodedRow, _ key: String) -> Bool? {
        guard let val = row[key] as? Bool else { return nil }
        return val
    }

    static func getInt(_ row: DecodedRow, _ key: String) -> Int? {
        guard let val = row[key] as? Int else { return nil }
        return val
    }

    static func getDouble(_ row: DecodedRow, _ key: String) -> Double? {
        guard let val = row[key] as? Double else { return nil }
        return val
    }

    static func getDate(_ row: DecodedRow, _ key: String) -> Date? {
        guard let val = row[key] as? Date else { return nil }
        return val
    }

    static func getURL(_ row: DecodedRow, _ key: String) -> URL? {
        guard let val = row[key] as? URL else { return nil }
        return val
    }
}
