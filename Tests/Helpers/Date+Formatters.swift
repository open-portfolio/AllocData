//
//  Date+Formatters.swift
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

public extension Date {
    // format a date when the WASM compiler doesn't allow DateFormatters
    static func formatYYYYMMDD(_ date: Date?) -> String? {
        guard let date_ = date else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date_)
        guard let year = components.year,
              let month = components.month,
              let day = components.day
        else { return nil }
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
}
