//
//  AllocKeyed1.swift
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

public protocol AllocKeyed: Hashable {
    associatedtype Key: Hashable, Codable

    var primaryKey: Key { get }
    static var emptyKey: Key { get }
}

public extension AllocKeyed {
    typealias NormalizedID = String

    static func normalizeID(_ component: String?) -> NormalizedID {
        component?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
    }
}

public extension AllocKeyed {
    static func makeAllocMap<T: AllocKeyed>(_ elements: [T]) -> [T.Key: T] {
        let keys: [T.Key] = elements.map(\.primaryKey)
        return Dictionary(zip(keys, elements), uniquingKeysWith: { old, _ in old })
    }
}
