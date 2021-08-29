//
//  MValuationTransactionTests.swift
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

class MValuationTransactionTests: XCTestCase {
    let timestamp = Date()
    let formatter = ISO8601DateFormatter()

    func testSchema() {
        let expected = AllocSchema.allocValuationHistory
        let actual = MValuationHistory.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MValuationHistory(transactedAt: timestamp, accountID: "1", securityID: "BND", lotID: "3", shareCount: 23, sharePrice: 25, transactionID: "B")
        var actual = MValuationHistory(transactedAt: timestamp, accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, sharePrice: 5, transactionID: "A")
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("BND", actual.securityID)
        XCTAssertEqual("3", actual.lotID)
        XCTAssertEqual(3, actual.shareCount)
        XCTAssertEqual(5, actual.sharePrice)
        XCTAssertEqual("A", actual.transactionID)
        actual.shareCount = 23
        actual.sharePrice = 25
        actual.transactionID = "B"
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MValuationHistory(transactedAt: timestamp, accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, sharePrice: 5, transactionID: "B")
        let actual = try MValuationHistory(from: [
            MValuationHistory.CodingKeys.transactedAt.rawValue: timestamp,
            MValuationHistory.CodingKeys.accountID.rawValue: "1",
            MValuationHistory.CodingKeys.securityID.rawValue: "BND",
            MValuationHistory.CodingKeys.lotID.rawValue: "3",
            MValuationHistory.CodingKeys.shareCount.rawValue: 3,
            MValuationHistory.CodingKeys.sharePrice.rawValue: 5,
            MValuationHistory.CodingKeys.transactionID.rawValue: "B",
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MValuationHistory(transactedAt: timestamp, accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, sharePrice: 5, transactionID: "A")
        let finRow: MValuationHistory.Row = [
            MValuationHistory.CodingKeys.transactedAt.rawValue: timestamp + 1000, // IGNORED
            MValuationHistory.CodingKeys.accountID.rawValue: "x", // IGNORED
            MValuationHistory.CodingKeys.securityID.rawValue: "xx", // IGNORED
            MValuationHistory.CodingKeys.lotID.rawValue: "xxx", // IGNORED
            MValuationHistory.CodingKeys.shareCount.rawValue: 23,
            MValuationHistory.CodingKeys.sharePrice.rawValue: 25,
            MValuationHistory.CodingKeys.transactionID.rawValue: "B",
        ]
        try actual.update(from: finRow)
        let expected = MValuationHistory(transactedAt: timestamp, accountID: "1", securityID: "BND", lotID: "3", shareCount: 23, sharePrice: 25, transactionID: "B")
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MValuationHistory(transactedAt: timestamp, accountID: " A-x?3 ", securityID: " -3B ! ", lotID: "   ", shareCount: 3, sharePrice: 5)
        let refEpoch = timestamp.timeIntervalSinceReferenceDate
        let formattedDate = String(format: "%010.0f", refEpoch)
        let actual = element.primaryKey
        let expected = "\(formattedDate),a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let refEpoch = timestamp.timeIntervalSinceReferenceDate
        let formattedDate = String(format: "%010.0f", refEpoch)
        let finRow: MValuationHistory.Row = [
            "valuationHistoryTransactedAt": timestamp,
            "valuationHistoryAccountID": " A-x?3 ",
            "valuationHistorySecurityID": " -3B ! ",
            "valuationHistoryLotID": "   ",
        ]
        let actual = try MValuationHistory.getPrimaryKey(finRow)
        let expected = "\(formattedDate),a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let formattedDate = formatter.string(for: timestamp)!
        let parsedDate = formatter.date(from: formattedDate)
        let rawRows: [MValuationHistory.RawRow] = [[
            "valuationHistoryTransactedAt": formattedDate,
            "valuationHistoryAccountID": "1",
            "valuationHistorySecurityID": "BND",
            "valuationHistoryLotID": "3",
            "shareCount": "9",
            "sharePrice": "7",
            "transactionID": "A",
        ]]
        var rejected = [MValuationHistory.Row]()
        let actual = try MValuationHistory.decode(rawRows, rejectedRows: &rejected)
        let expected: MValuationHistory.Row = [
            "valuationHistoryTransactedAt": parsedDate,
            "valuationHistoryAccountID": "1",
            "valuationHistorySecurityID": "BND",
            "valuationHistoryLotID": "3",
            "shareCount": 9,
            "sharePrice": 7,
            "transactionID": "A",
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
