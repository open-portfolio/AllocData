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
        let expected = AllocSchema.allocValuationTransaction
        let actual = MValuationTransaction.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MValuationTransaction(transactedAt: timestamp, accountID: "1", securityID: "BND", lotID: "3", shareCount: 23, sharePrice: 25)
        var actual = MValuationTransaction(transactedAt: timestamp, accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, sharePrice: 5)
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("BND", actual.securityID)
        XCTAssertEqual("3", actual.lotID)
        XCTAssertEqual(3, actual.shareCount)
        XCTAssertEqual(5, actual.sharePrice)
        actual.shareCount = 23
        actual.sharePrice = 25
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MValuationTransaction(transactedAt: timestamp, accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, sharePrice: 5)
        let actual = try MValuationTransaction(from: [
            MValuationTransaction.CodingKeys.transactedAt.rawValue: timestamp,
            MValuationTransaction.CodingKeys.accountID.rawValue: "1",
            MValuationTransaction.CodingKeys.securityID.rawValue: "BND",
            MValuationTransaction.CodingKeys.lotID.rawValue: "3",
            MValuationTransaction.CodingKeys.shareCount.rawValue: 3,
            MValuationTransaction.CodingKeys.sharePrice.rawValue: 5,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MValuationTransaction(transactedAt: timestamp, accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, sharePrice: 5)
        let finRow: MValuationTransaction.Row = [
            MValuationTransaction.CodingKeys.transactedAt.rawValue: timestamp + 1000, // IGNORED
            MValuationTransaction.CodingKeys.accountID.rawValue: "x", // IGNORED
            MValuationTransaction.CodingKeys.securityID.rawValue: "xx", // IGNORED
            MValuationTransaction.CodingKeys.lotID.rawValue: "xxx", // IGNORED
            MValuationTransaction.CodingKeys.shareCount.rawValue: 23,
            MValuationTransaction.CodingKeys.sharePrice.rawValue: 25,
        ]
        try actual.update(from: finRow)
        let expected = MValuationTransaction(transactedAt: timestamp, accountID: "1", securityID: "BND", lotID: "3", shareCount: 23, sharePrice: 25)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MValuationTransaction(transactedAt: timestamp, accountID: " A-x?3 ", securityID: " -3B ! ", lotID: "   ", shareCount: 3, sharePrice: 5)
        //let formattedDate = generateYYYYMMDD2(timestamp) ?? ""
        //let formattedDate = formatter.string(for: timestamp)!
        let refEpoch = timestamp.timeIntervalSinceReferenceDate
        let formattedDate = String(format: "%010.0f", refEpoch)
        
        let actual = element.primaryKey
        let expected = "\(formattedDate),a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        //let formattedDate = generateYYYYMMDD2(timestamp) ?? ""
        //let formattedDate = formatter.string(for: timestamp)!
        let refEpoch = timestamp.timeIntervalSinceReferenceDate
        let formattedDate = String(format: "%010.0f", refEpoch)
        let finRow: MValuationTransaction.Row = [
            "valuationTransactionTransactedAt": timestamp,
            "valuationTransactionAccountID": " A-x?3 ",
            "valuationTransactionSecurityID": " -3B ! ",
            "valuationTransactionLotID": "   ",
        ]
        let actual = try MValuationTransaction.getPrimaryKey(finRow)
        let expected = "\(formattedDate),a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let formattedDate = formatter.string(for: timestamp)!
        let parsedDate = formatter.date(from: formattedDate)
        let rawRows: [MValuationTransaction.RawRow] = [[
            "valuationTransactionTransactedAt": formattedDate,
            "valuationTransactionAccountID": "1",
            "valuationTransactionSecurityID": "BND",
            "valuationTransactionLotID": "3",
            "shareCount": "9",
            "sharePrice": "7",
        ]]
        var rejected = [MValuationTransaction.Row]()
        let actual = try MValuationTransaction.decode(rawRows, rejectedRows: &rejected)
        let expected: MValuationTransaction.Row = [
            "valuationTransactionTransactedAt": parsedDate,
            "valuationTransactionAccountID": "1",
            "valuationTransactionSecurityID": "BND",
            "valuationTransactionLotID": "3",
            "shareCount": 9,
            "sharePrice": 7,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
