//
//  MValuationCashflowTests.swift
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

class MValuationCashflowTests: XCTestCase {
    let timestamp = Date()
    let formatter = ISO8601DateFormatter()

    func testSchema() {
        let expected = AllocSchema.allocValuationCashflow
        let actual = MValuationCashflow.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MValuationCashflow(cashflowID: "X", transactedAt: timestamp, accountID: "1", assetID: "Bond", marketValue: 23)
        var actual = MValuationCashflow(cashflowID: "X", transactedAt: timestamp, accountID: "1", assetID: "Bond", marketValue: 3)
        XCTAssertEqual("X", actual.cashflowID)
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("Bond", actual.assetID)
        XCTAssertEqual(3, actual.marketValue)
        actual.marketValue = 23
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MValuationCashflow(cashflowID: "X", transactedAt: timestamp, accountID: "1", assetID: "Bond", marketValue: 3)
        let actual = try MValuationCashflow(from: [
            MValuationCashflow.CodingKeys.cashflowID.rawValue: "X",
            MValuationCashflow.CodingKeys.transactedAt.rawValue: timestamp,
            MValuationCashflow.CodingKeys.accountID.rawValue: "1",
            MValuationCashflow.CodingKeys.assetID.rawValue: "Bond",
            MValuationCashflow.CodingKeys.marketValue.rawValue: 3,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MValuationCashflow(cashflowID: "X", transactedAt: timestamp, accountID: "1", assetID: "Bond", marketValue: 3)
        let finRow: MValuationCashflow.Row = [
            MValuationCashflow.CodingKeys.cashflowID.rawValue: "1", // IGNORED
            MValuationCashflow.CodingKeys.transactedAt.rawValue: timestamp + 1000, // IGNORED
            MValuationCashflow.CodingKeys.accountID.rawValue: "x", // IGNORED
            MValuationCashflow.CodingKeys.assetID.rawValue: "xx", // IGNORED
            MValuationCashflow.CodingKeys.marketValue.rawValue: 23,
        ]
        try actual.update(from: finRow)
        let expected = MValuationCashflow(cashflowID: "X", transactedAt: timestamp, accountID: "1", assetID: "Bond", marketValue: 23)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MValuationCashflow(cashflowID: "  X  ", transactedAt: timestamp, accountID: " A-x?3 ", assetID: " -3B ! ", marketValue: 3)
        let actual = element.primaryKey
        let expected = "x"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MValuationCashflow.Row = [
            "valuationCashflowID": "   X   ",
            "transactedAt": timestamp,
            "accountID": " A-x?3 ",
            "assetID": " -3B ! ",
        ]
        let actual = try MValuationCashflow.getPrimaryKey(finRow)
        let expected = "x"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let formattedDate = formatter.string(for: timestamp)!
        let parsedDate = formatter.date(from: formattedDate)
        let rawRows: [MValuationCashflow.RawRow] = [[
            "valuationCashflowID": "   X   ",
            "transactedAt": formattedDate,
            "accountID": "1",
            "assetID": "Bond",
            "marketValue": "9",
        ]]
        var rejected = [MValuationCashflow.Row]()
        let actual = try MValuationCashflow.decode(rawRows, rejectedRows: &rejected)
        let expected: MValuationCashflow.Row = [
            "valuationCashflowID": "X",
            "transactedAt": parsedDate,
            "accountID": "1",
            "assetID": "Bond",
            "marketValue": 9,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
