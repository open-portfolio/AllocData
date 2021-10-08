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
        let expected = MValuationSnapshot(snapshotID: "XYZ", capturedAt: timestamp2)
        var actual = MValuationSnapshot(snapshotID: "XYZ", capturedAt: timestamp)
        XCTAssertEqual("XYZ", actual.snapshotID)
        XCTAssertEqual(timestamp, actual.capturedAt)
        actual.capturedAt = timestamp2
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MValuationSnapshot(snapshotID: "XYZ", capturedAt: timestamp)
        let actual = try MValuationSnapshot(from: [
            MValuationSnapshot.CodingKeys.snapshotID.rawValue: "XYZ",
            MValuationSnapshot.CodingKeys.capturedAt.rawValue: timestamp,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MValuationSnapshot(snapshotID: "XYZ", capturedAt: timestamp)
        let finRow: MValuationSnapshot.DecodedRow = [
            MValuationSnapshot.CodingKeys.snapshotID.rawValue: "ABC", // ignored
            MValuationSnapshot.CodingKeys.capturedAt.rawValue: timestamp2,
        ]
        try actual.update(from: finRow)
        let expected = MValuationSnapshot(snapshotID: "XYZ", capturedAt: timestamp2)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MValuationSnapshot(snapshotID: "  XYZ  ", capturedAt: timestamp)
        let actual = element.primaryKey
        let expected = MValuationSnapshot.Key(snapshotID: "  XYZ  ")
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MValuationSnapshot.DecodedRow = [
            MValuationSnapshot.CodingKeys.snapshotID.rawValue: "  ABC  ",
            MValuationSnapshot.CodingKeys.capturedAt.rawValue: timestamp,
        ]
        let actual = try MValuationSnapshot.getPrimaryKey(finRow)
        let expected = MValuationSnapshot.Key(snapshotID: "  ABC  ")
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let formattedDate = formatter.string(for: timestamp)!
        let parsedDate = formatter.date(from: formattedDate)!
        let rawRows: [MValuationSnapshot.RawRow] = [[
            MValuationSnapshot.CodingKeys.snapshotID.rawValue: "XYZ",
            MValuationSnapshot.CodingKeys.capturedAt.rawValue: formattedDate,
        ]]
        var rejected = [MValuationSnapshot.RawRow]()
        let actual = try MValuationSnapshot.decode(rawRows, rejectedRows: &rejected)
        let expected: MValuationSnapshot.DecodedRow = [
            MValuationSnapshot.CodingKeys.snapshotID.rawValue: "XYZ",
            MValuationSnapshot.CodingKeys.capturedAt.rawValue: parsedDate,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
