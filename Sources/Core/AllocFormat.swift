//
//  AllocFormat.swift
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

public enum AllocFormat: String, CaseIterable {
    case JSON = "application/json"
    case CSV = "text/csv"
    case TSV = "text/tab-separated-values"

    public static func guess(fromURL url: URL?) -> AllocFormat? {
        guard let url_ = url else { return nil }
        return guess(fromFileExtension: url_.pathExtension)
    }

    public static func guess(fromFileExtension ext: String?) -> AllocFormat? {
        guard let ext_ = ext else { return nil }
        let cleaned = ext_.trimmingCharacters(in: .whitespaces).lowercased()
        guard cleaned.count > 0 else { return nil }
        return AllocFormat.allCases.first(where: { $0.defaultFileExtension == cleaned })
    }

    public var delimiter: Character? {
        switch self {
        case .CSV:
            return ","
        case .TSV:
            return "\t"
        default:
            return nil
        }
    }

    public var defaultFileExtension: String? {
        switch self {
        case .JSON:
            return "json"
        case .CSV:
            return "csv"
        case .TSV:
            return "tsv"
        }
    }
}
