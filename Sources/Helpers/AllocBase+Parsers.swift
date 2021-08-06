//
//  AllocBase+Parsers.swift
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

// ISO8601DateFormatter requires macOS 10.12 or later.
// It could conceivably be replaced with an implementation that is more broadly supported.
fileprivate let isoDateFormatter = ISO8601DateFormatter()

public extension AllocBase {
    
    static func parseDate(_ rawVal: String?) -> Date? {
        guard let val = rawVal else { return nil }
        return isoDateFormatter.date(from: val)
    }
    
    static func unparseDate(_ dateVal: Date) -> String {
        return isoDateFormatter.string(from: dateVal)
    }
}


public extension AllocBase {
    static func parseUUID(_ rawVal: String?, trimCharacters _: CharacterSet = CharacterSet()) -> UUID? {
        guard let uuidString = parseString(rawVal) else { return nil }
        return UUID(uuidString: uuidString)
    }

    // Trim and parse string. Return nil if blank.
    static func parseString(_ rawVal: String?, trimCharacters: CharacterSet = CharacterSet()) -> String? {
        let trimChars = trimCharacters.union(.whitespaces)
        if let trimmed = rawVal?.trimmingCharacters(in: trimChars),
           trimmed.count > 0
        {
            return trimmed
        }
        return nil
    }

    // parse without benefit of a number formatter
    // +$11,945.20 to 11945.20
    static func parseDouble(_ rawVal: String?) -> Double? {
        guard let val = rawVal else { return nil }
        let cleanVal = String(val.filter { "0123456789.-".contains($0) })
        return Double(cleanVal)
    }

    // parse without benefit of a number formatter
    // +$11,945 to 11945
    static func parseInt(_ rawVal: String?) -> Int? {
        guard let val = rawVal else { return nil }
        let cleanVal = String(val.filter { "0123456789.-".contains($0) })
        return Int(cleanVal)
    }

    static func parseBool(_ rawVal: String?) -> Bool? {
        guard let val = rawVal?.lowercased() else { return nil }
        return Bool(val)
    }

    // parse without benefit of a number formatter
    // Does NOT require a percent sign
    // Rounded by Int(rawPercent * precision) / precision
    // Result divided by 100
    // -90.3% to -0.903
    // 1,000.3% to 10.003
    static func parsePercent(_ percentStr: String?, precision: Double = 100) -> Double? {
        guard let val = parseDouble(percentStr) else { return nil }
        return Double(Int(val * precision)) / (precision * 100)
    }

    // YYYY-MM-DD date parser
    static func parseYYYYMMDD(_ dateStr: String?, separator: Character = "-") -> Date? {
        guard let components = dateStr?.trimmingCharacters(in: .whitespaces).split(separator: separator),
              components.count == 3,
              components[0].count == 4,
              components[1].count == 2,
              components[2].count == 2,
              let year = Int(components[0]),
              let month = Int(components[1]),
              let day = Int(components[2]),
              let date = DateComponents(calendar: .current, year: year, month: month, day: day).date
        else { return nil }

        return date
    }

    // MM/DD/YYYY date parser
    static func parseMMDDYYYY(_ dateStr: String?, separator: Character = "-") -> Date? {
        guard let components = dateStr?.trimmingCharacters(in: .whitespaces).split(separator: separator),
              components.count == 3,
              components[0].count == 2,
              components[1].count == 2,
              components[2].count == 4,
              let year = Int(components[2]),
              let month = Int(components[0]),
              let day = Int(components[1]),
              let date = DateComponents(calendar: .current, year: year, month: month, day: day).date
        else { return nil }

        return date
    }
}
