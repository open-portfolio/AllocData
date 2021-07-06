//
//  MCapTests.swift
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

class MCapTests: XCTestCase {
    func testSchema() {
        let expected = AllocSchema.allocCap
        let actual = MCap.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MCap(accountID: "1", assetID: "Bond", limitPct: 0.77)
        var actual = MCap(accountID: "1", assetID: "Bond")
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("Bond", actual.assetID)
        XCTAssertEqual(MCap.defaultLimitPct, actual.limitPct)
        actual.limitPct = 0.77
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MCap(accountID: "1", assetID: "Bond", limitPct: 0.77)
        let actual = try MCap(from: [
            MCap.CodingKeys.accountID.rawValue: "1",
            MCap.CodingKeys.assetID.rawValue: "Bond",
            MCap.CodingKeys.limitPct.rawValue: 0.77,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MCap(accountID: "1", assetID: "Bond", limitPct: 0.77)
        let finRow: MCap.Row = [
            MCap.CodingKeys.accountID.rawValue: "x", // IGNORED
            MCap.CodingKeys.assetID.rawValue: "xx", // IGNORED
            MCap.CodingKeys.limitPct.rawValue: 0.88,
        ]
        try actual.update(from: finRow)
        let expected = MCap(accountID: "1", assetID: "Bond", limitPct: 0.88)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MCap(accountID: " A-x?3 ", assetID: " -3B ! ")
        let actual = element.primaryKey
        let expected = "a-x?3,-3b !"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MCap.Row = ["capAccountID": " A-x?3 ", "capAssetID": " -3B ! "]
        let actual = try MCap.getPrimaryKey(finRow)
        let expected = "a-x?3,-3b !"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MCap.RawRow] = [[
            "capAccountID": "1",
            "capAssetID": "Bond",
            "limitPct": "0.77",
        ]]
        var rejected = [MCap.Row]()
        let actual = try MCap.decode(rawRows, rejectedRows: &rejected)
        let expected: MCap.Row = [
            "capAccountID": "1",
            "capAssetID": "Bond",
            "limitPct": 0.77,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
