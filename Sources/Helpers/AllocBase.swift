//
//  AllocBase.swift
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

public protocol AllocBase: Codable {
    // pre-decoded row, without strong typing
    typealias RawRow = [String: String]

    // decoded row, with strong typing
    typealias Row = [String: AnyHashable?]

    static var schema: AllocSchema { get }
    static var attributes: [AllocAttribute] { get }

    // Note that key values should NOT be persisted. Their
    // format and composition may vary across platforms and
    // versions.
    var primaryKey: AllocKey { get }

    // create object from row
    init(from row: Row) throws

    // additive update from row
    mutating func update(from row: Row) throws

    static func getPrimaryKey(_ row: Row) throws -> AllocKey

    static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row]
}
