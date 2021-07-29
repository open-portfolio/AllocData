//
//  AllocRowUtils.swift
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

public extension AllocBase {
    static func getStr(_ row: Row, _ key: String) -> String? {
        if let val = row[key] as? String {
            return val
        }

        // note that value may be a slice, in which case it does NOT cast as string
        if let val = row[key] as? Substring {
            return String(val)
        }

        return nil
    }

    static func getBool(_ row: Row, _ key: String) -> Bool? {
        guard let val = row[key] as? Bool else { return nil }
        return val
    }

    static func getInt(_ row: Row, _ key: String) -> Int? {
        guard let val = row[key] as? Int else { return nil }
        return val
    }

    static func getDouble(_ row: Row, _ key: String) -> Double? {
        guard let val = row[key] as? Double else { return nil }
        return val
    }

    static func getDate(_ row: Row, _ key: String) -> Date? {
        guard let val = row[key] as? Date else { return nil }
        return val
    }
}
