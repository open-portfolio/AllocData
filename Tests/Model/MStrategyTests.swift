//
//  MStrategyTests.swift
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

@testable import AllocData
import XCTest

class MStrategyTests: XCTestCase {
    func testSchema() {
        let expected = AllocSchema.allocStrategy
        let actual = MStrategy.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MStrategy(strategyID: "a", title: "b")
        var actual = MStrategy(strategyID: "a")
        XCTAssertNil(actual.title)
        actual.title = "b"
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MStrategy(strategyID: "a", title: "b")
        let actual = try MStrategy(from: [
            MStrategy.CodingKeys.strategyID.rawValue: "a",
            MStrategy.CodingKeys.title.rawValue: "b",
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MStrategy(strategyID: "a", title: "b")
        let finRow: MStrategy.DecodedRow = [
            MStrategy.CodingKeys.strategyID.rawValue: "c", // IGNORED
            MStrategy.CodingKeys.title.rawValue: "e",
        ]
        try actual.update(from: finRow)
        let expected = MStrategy(strategyID: "a", title: "e")
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let account = MStrategy(strategyID: " A-x?3 ")
        let actual = account.primaryKey
        let expected = MStrategy.Key(strategyID: " A-x?3 ")
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MStrategy.DecodedRow = ["strategyID": " A-x?3 "]
        let actual = try MStrategy.getPrimaryKey(finRow)
        let expected = MStrategy.Key(strategyID: " A-x?3 ")
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MStrategy.RawRow] = [[
            "strategyID": "a",
            "title": "b",
        ]]
        var rejected = [MStrategy.RawRow]()
        let actual = try MStrategy.decode(rawRows, rejectedRows: &rejected)
        let expected: MStrategy.DecodedRow = [
            "strategyID": "a",
            "title": "b",
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
