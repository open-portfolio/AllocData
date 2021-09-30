//
//  MValuationAccountTests.swift
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

class MValuationAccountTests: XCTestCase {
    let timestamp = Date()

    func testSchema() {
        let expected = AllocSchema.allocValuationAccount
        let actual = MValuationAccount.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        let expected = MValuationAccount(snapshotID: beg.snapshotID, accountID: "1", strategyID: "333")
        var actual = MValuationAccount(snapshotID: beg.snapshotID, accountID: "1", strategyID: "444")
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("444", actual.strategyID)
        actual.strategyID = "333"
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        let expected = MValuationAccount(snapshotID: beg.snapshotID, accountID: "1", strategyID: "333")
        let actual = try MValuationAccount(from: [
            MValuationAccount.CodingKeys.snapshotID.rawValue: "B",
            MValuationAccount.CodingKeys.accountID.rawValue: "1",
            MValuationAccount.CodingKeys.strategyID.rawValue: "333",
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        var actual = MValuationAccount(snapshotID: beg.snapshotID, accountID: "1", strategyID: "333")
        let finRow: MValuationAccount.DecodedRow = [
            MValuationAccount.CodingKeys.snapshotID.rawValue: "Z", // IGNORED
            MValuationAccount.CodingKeys.accountID.rawValue: "x", // IGNORED
            MValuationAccount.CodingKeys.strategyID.rawValue: "333",
        ]
        try actual.update(from: finRow)
        let expected = MValuationAccount(snapshotID: beg.snapshotID, accountID: "1", strategyID: "333")
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        let element = MValuationAccount(snapshotID: beg.snapshotID, accountID: " A-x?3 ", strategyID: "333")
        let actual = element.primaryKey
        let expected = "b,a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MValuationAccount.DecodedRow = [
            "valuationAccountSnapshotID": " B  ",
            "valuationAccountAccountID": " A-x?3 ",
            "strategyID": "333",
        ]
        let actual = try MValuationAccount.getPrimaryKey(finRow)
        let expected = "b,a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MValuationAccount.RawRow] = [[
            "valuationAccountSnapshotID": "B",
            "valuationAccountAccountID": "1",
            "strategyID": "333",
        ]]
        var rejected = [MValuationAccount.RawRow]()
        let actual = try MValuationAccount.decode(rawRows, rejectedRows: &rejected)
        let expected: MValuationAccount.DecodedRow = [
            "valuationAccountSnapshotID": "B",
            "valuationAccountAccountID": "1",
            "strategyID": "333",
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
