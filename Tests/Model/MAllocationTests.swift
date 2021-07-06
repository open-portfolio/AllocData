//
//  MAllocationTests.swift
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

class MAllocationTests: XCTestCase {
    func testSchema() {
        let expected = AllocSchema.allocAllocation
        let actual = MAllocation.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MAllocation(strategyID: "1", assetID: "Bond", targetPct: 0.77, isLocked: true)
        var actual = MAllocation(strategyID: "1", assetID: "Bond")
        XCTAssertEqual("1", actual.strategyID)
        XCTAssertEqual("Bond", actual.assetID)
        XCTAssertEqual(MAllocation.defaultTargetPct, actual.targetPct)
        XCTAssertFalse(actual.isLocked)
        actual.targetPct = 0.77
        actual.isLocked = true
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MAllocation(strategyID: "1", assetID: "Bond", targetPct: 0.77, isLocked: true)
        let actual = try MAllocation(from: [
            MAllocation.CodingKeys.strategyID.rawValue: "1",
            MAllocation.CodingKeys.assetID.rawValue: "Bond",
            MAllocation.CodingKeys.targetPct.rawValue: 0.77,
            MAllocation.CodingKeys.isLocked.rawValue: true,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MAllocation(strategyID: "1", assetID: "Bond", targetPct: 0.77, isLocked: false)
        let finRow: MAllocation.Row = [
            MAllocation.CodingKeys.strategyID.rawValue: "x", // IGNORED
            MAllocation.CodingKeys.assetID.rawValue: "xx", // IGNORED
            MAllocation.CodingKeys.targetPct.rawValue: 0.88,
            MAllocation.CodingKeys.isLocked.rawValue: true,
        ]
        try actual.update(from: finRow)
        let expected = MAllocation(strategyID: "1", assetID: "Bond", targetPct: 0.88, isLocked: true)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MAllocation(strategyID: " A-x?3 ", assetID: " -3B ! ")
        let actual = element.primaryKey
        let expected = "a-x?3,-3b !"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MAllocation.Row = ["allocationStrategyID": " A-x?3 ", "allocationAssetID": " -3B ! "]
        let actual = try MAllocation.getPrimaryKey(finRow)
        let expected = "a-x?3,-3b !"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MAllocation.RawRow] = [[
            "allocationStrategyID": "1",
            "allocationAssetID": "Bond",
            "targetPct": "0.77",
            "isLocked": "true",
        ]]
        var rejected = [MAllocation.Row]()
        let actual = try MAllocation.decode(rawRows, rejectedRows: &rejected)
        let expected: MAllocation.Row = [
            "allocationStrategyID": "1",
            "allocationAssetID": "Bond",
            "targetPct": 0.77,
            "isLocked": true,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
