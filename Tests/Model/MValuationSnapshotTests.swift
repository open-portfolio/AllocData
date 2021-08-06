//
//  MValuationSnapshotTests.swift
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

class MValuationSnapshotTests: XCTestCase {
    let timestamp = Date()
    let timestamp2 = Date() + 20000
    let formatter = ISO8601DateFormatter()
    
    func testSchema() {
        let expected = AllocSchema.allocValuationSnapshot
        let actual = MValuationSnapshot.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MValuationSnapshot(valuationSnapshotID: "XYZ", capturedAt: timestamp2)
        var actual = MValuationSnapshot(valuationSnapshotID: "XYZ", capturedAt: timestamp)
        XCTAssertEqual("XYZ", actual.valuationSnapshotID)
        XCTAssertEqual(timestamp, actual.capturedAt)
        actual.capturedAt = timestamp2
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MValuationSnapshot(valuationSnapshotID: "XYZ", capturedAt: timestamp)
        let actual = try MValuationSnapshot(from: [
            MValuationSnapshot.CodingKeys.valuationSnapshotID.rawValue: "XYZ",
            MValuationSnapshot.CodingKeys.capturedAt.rawValue: timestamp,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MValuationSnapshot(valuationSnapshotID: "XYZ", capturedAt: timestamp)
        let finRow: MValuationSnapshot.Row = [
            MValuationSnapshot.CodingKeys.valuationSnapshotID.rawValue: "ABC",  // ignored
            MValuationSnapshot.CodingKeys.capturedAt.rawValue: timestamp2,
        ]
        try actual.update(from: finRow)
        let expected = MValuationSnapshot(valuationSnapshotID: "XYZ", capturedAt: timestamp2)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MValuationSnapshot(valuationSnapshotID: "  XYZ  ", capturedAt: timestamp)
        let actual = element.primaryKey
        let expected = "xyz"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MValuationSnapshot.Row = [
            MValuationSnapshot.CodingKeys.valuationSnapshotID.rawValue: "  ABC  ",
            MValuationSnapshot.CodingKeys.capturedAt.rawValue: timestamp,
        ]
        let actual = try MValuationSnapshot.getPrimaryKey(finRow)
        let expected = "abc"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        //let formattedDate = generateYYYYMMDD2(timestamp) ?? ""
        let formattedDate = formatter.string(for: timestamp)!
        //let parsedDate = parseYYYYMMDD(formattedDate)
        let parsedDate = formatter.date(from: formattedDate)
        let rawRows: [MValuationSnapshot.RawRow] = [[
            MValuationSnapshot.CodingKeys.valuationSnapshotID.rawValue: "XYZ",
            MValuationSnapshot.CodingKeys.capturedAt.rawValue: formattedDate,
        ]]
        var rejected = [MValuationSnapshot.Row]()
        let actual = try MValuationSnapshot.decode(rawRows, rejectedRows: &rejected)
        let expected: MValuationSnapshot.Row = [
            MValuationSnapshot.CodingKeys.valuationSnapshotID.rawValue: "XYZ",
            MValuationSnapshot.CodingKeys.capturedAt.rawValue: parsedDate,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
