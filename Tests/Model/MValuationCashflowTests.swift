//
//  MValuationCashflowTests.swift
//
// Copyright 2021, 2022 OpenAlloc LLC
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
        let expected = MValuationCashflow(transactedAt: timestamp, accountID: "1", assetID: "Bond", amount: 23)
        var actual = MValuationCashflow(transactedAt: timestamp, accountID: "1", assetID: "Bond", amount: 3)
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("Bond", actual.assetID)
        XCTAssertEqual(3, actual.amount)
        actual.amount = 23
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MValuationCashflow(transactedAt: timestamp, accountID: "1", assetID: "Bond", amount: 3)
        let actual = try MValuationCashflow(from: [
            MValuationCashflow.CodingKeys.transactedAt.rawValue: timestamp,
            MValuationCashflow.CodingKeys.accountID.rawValue: "1",
            MValuationCashflow.CodingKeys.assetID.rawValue: "Bond",
            MValuationCashflow.CodingKeys.amount.rawValue: 3,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MValuationCashflow(transactedAt: timestamp, accountID: "1", assetID: "Bond", amount: 3)
        let finRow: MValuationCashflow.DecodedRow = [
            MValuationCashflow.CodingKeys.transactedAt.rawValue: timestamp + 1000, // IGNORED
            MValuationCashflow.CodingKeys.accountID.rawValue: "x", // IGNORED
            MValuationCashflow.CodingKeys.assetID.rawValue: "xx", // IGNORED
            MValuationCashflow.CodingKeys.amount.rawValue: 23,
        ]
        try actual.update(from: finRow)
        let expected = MValuationCashflow(transactedAt: timestamp, accountID: "1", assetID: "Bond", amount: 23)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MValuationCashflow(transactedAt: timestamp, accountID: " A-x?3 ", assetID: " -3B ! ", amount: 3)
        let actual = element.primaryKey
        let expected = MValuationCashflow.Key(transactedAt: timestamp, accountID: " A-x?3 ", assetID: " -3B ! ")
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MValuationCashflow.DecodedRow = [
            "valuationCashflowTransactedAt": timestamp,
            "valuationCashflowAccountID": " A-x?3 ",
            "valuationCashflowAssetID": " -3B ! ",
        ]
        let actual = try MValuationCashflow.getPrimaryKey(finRow)
        let expected = MValuationCashflow.Key(transactedAt: timestamp, accountID: " A-x?3 ", assetID: " -3B ! ")
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let formattedDate = formatter.string(for: timestamp)!
        let parsedDate = formatter.date(from: formattedDate)!
        let rawRows: [MValuationCashflow.RawRow] = [[
            "valuationCashflowTransactedAt": formattedDate,
            "valuationCashflowAccountID": "1",
            "valuationCashflowAssetID": "Bond",
            "amount": "9",
        ]]
        var rejected = [MValuationCashflow.RawRow]()
        let actual = try MValuationCashflow.decode(rawRows, rejectedRows: &rejected)
        let expected: MValuationCashflow.DecodedRow = [
            "valuationCashflowTransactedAt": parsedDate,
            "valuationCashflowAccountID": "1",
            "valuationCashflowAssetID": "Bond",
            "amount": 9,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
