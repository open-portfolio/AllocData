//
//  AllocSchema+TableSignature.swift
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

public extension AllocSchema {
    typealias TableSignature = Set<String>

    var tableSignature: TableSignature {
        AllocAttribute.getSignature(attributes)
    }

    static var tableSignatureMap: [AllocSchema: TableSignature] =
        AllocSchema.allCases.reduce(into: [:]) { map, schema in
            map[schema] = schema.tableSignature
        }

    static func generateSignature(_ codingKeys: [CodingKey]) -> TableSignature {
        let codingKeyStrs = codingKeys.map(\.stringValue)
        return generateSignature(codingKeyStrs)
    }

    static func generateSignature(_ columnNames: [String]) -> TableSignature {
        let cleaned = columnNames.map { $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
        return Set(cleaned)
    }
}
