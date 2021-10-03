//
//  MTrackerTests.swift
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

class MTrackerTests: XCTestCase {
    func testSchema() {
        let expected = AllocSchema.allocTracker
        let actual = MTracker.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MTracker(trackerID: "a", title: "b")
        var actual = MTracker(trackerID: "a")
        XCTAssertNil(actual.title)
        actual.title = "b"
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MTracker(trackerID: "a", title: "b")
        let actual = try MTracker(from: [
            MTracker.CodingKeys.trackerID.rawValue: "a",
            MTracker.CodingKeys.title.rawValue: "b",
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MTracker(trackerID: "a", title: "b")
        let finRow: MTracker.DecodedRow = [
            MTracker.CodingKeys.trackerID.rawValue: "c", // IGNORED
            MTracker.CodingKeys.title.rawValue: "e",
        ]
        try actual.update(from: finRow)
        let expected = MTracker(trackerID: "a", title: "e")
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let account = MTracker(trackerID: " A-x?3 ")
        let actual = account.primaryKey
        let expected = "a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MTracker.DecodedRow = ["trackerID": " A-x?3 "]
        let actual = try MTracker.getPrimaryKey(finRow)
        let expected = "a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MTracker.RawRow] = [[
            "trackerID": "a",
            "title": "b",
        ]]
        var rejected = [MTracker.RawRow]()
        let actual = try MTracker.decode(rawRows, rejectedRows: &rejected)
        let expected: MTracker.DecodedRow = [
            "trackerID": "a",
            "title": "b",
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
