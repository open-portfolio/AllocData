//
//  AllocKeyed1.swift
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

public protocol AllocKeyed: Hashable {
    associatedtype Key: Equatable
    
    typealias NormalizedID = String
    
    var primaryKey: Key { get }
}

public extension AllocKeyed {
    static func makeAllocMap<T: AllocKeyed>(_ elements: [T]) -> [T.Key: T] {
        let keys: [T.Key] = elements.map(\.primaryKey)
        return Dictionary(zip(keys, elements), uniquingKeysWith: { old, _ in old })
    }
    
    static func normalizeID(_ component: String?) -> NormalizedID {
        component?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
    }
}

//public protocol AllocKeyed1 {
//    // Note that key values should NOT be persisted. Their format and composition may vary across platforms and versions.
//    var primaryKey1: AllocKey { get }
//
//    static func keyify(_ component: String?) -> AllocKey
//    static func keyify(_ components: [String?]) -> AllocKey
//    static func makeAllocMap<T: AllocKeyed1>(_ elements: [T]) -> [AllocKey: T]
//}
//
//public extension AllocKeyed1 {
//    // an AllocKey is a normalized 'ID', trimmed and lowercased.
//    typealias AllocKey = String
//
//    static func keyify(_ component: String?) -> AllocKey {
//        component?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
//    }
//
//    static func keyify(_ components: [String?]) -> AllocKey {
//        let separator = ","
//        return
//            components
//                .map { $0?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }
//                .joined(separator: separator).lowercased()
//    }
//
//    static func makeAllocMap<T: AllocKeyed1>(_ elements: [T]) -> [AllocKey: T] {
//        let keys: [AllocKey] = elements.map(\.primaryKey1)
//        return Dictionary(zip(keys, elements), uniquingKeysWith: { old, _ in old })
//    }
//}
