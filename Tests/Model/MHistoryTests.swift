//
//  MHistoryTests.swift
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

class MHistoryTests: XCTestCase {
    lazy var timestamp = Date()
    lazy var df = ISO8601DateFormatter()

    func testSchema() {
        let expected = AllocSchema.allocHistory
        let actual = MHistory.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MHistory(transactionID: "1", accountID: "a", securityID: "s", lotID: "x", shareCount: 3, sharePrice: 4, realizedGainShort: 5, realizedGainLong: 6, transactedAt: timestamp)
        var actual = MHistory(transactionID: "1", accountID: "a", securityID: "s", lotID: "x")
        XCTAssertEqual("1", actual.transactionID)
        XCTAssertEqual("a", actual.accountID)
        XCTAssertEqual("s", actual.securityID)
        XCTAssertEqual("x", actual.lotID)
        XCTAssertNil(actual.shareCount)
        XCTAssertNil(actual.sharePrice)
        XCTAssertNil(actual.realizedGainShort)
        XCTAssertNil(actual.realizedGainLong)
        XCTAssertNil(actual.transactedAt)
        actual.shareCount = 3
        actual.sharePrice = 4
        actual.realizedGainShort = 5
        actual.realizedGainLong = 6
        actual.transactedAt = timestamp
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MHistory(transactionID: "1", accountID: "a", securityID: "s", lotID: "x", shareCount: 3, sharePrice: 4, realizedGainShort: 5, realizedGainLong: 6, transactedAt: timestamp)
        let actual = try MHistory(from: [
            MHistory.CodingKeys.transactionID.rawValue: "1",
            MHistory.CodingKeys.accountID.rawValue: "a",
            MHistory.CodingKeys.securityID.rawValue: "s",
            MHistory.CodingKeys.lotID.rawValue: "x",
            MHistory.CodingKeys.shareCount.rawValue: 3,
            MHistory.CodingKeys.sharePrice.rawValue: 4,
            MHistory.CodingKeys.realizedGainShort.rawValue: 5,
            MHistory.CodingKeys.realizedGainLong.rawValue: 6,
            MHistory.CodingKeys.transactedAt.rawValue: timestamp,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MHistory(transactionID: "1", accountID: "a", securityID: "s", lotID: "x", shareCount: 3, sharePrice: 4, realizedGainShort: 5, realizedGainLong: 6, transactedAt: timestamp)
        let finRow: MHistory.Row = [
            MHistory.CodingKeys.transactionID.rawValue: "x", // IGNORED
            MHistory.CodingKeys.accountID.rawValue: "b",
            MHistory.CodingKeys.securityID.rawValue: "c",
            MHistory.CodingKeys.lotID.rawValue: "z",
            MHistory.CodingKeys.shareCount.rawValue: 7,
            MHistory.CodingKeys.sharePrice.rawValue: 8,
            MHistory.CodingKeys.realizedGainShort.rawValue: 9,
            MHistory.CodingKeys.realizedGainLong.rawValue: 10,
            MHistory.CodingKeys.transactedAt.rawValue: timestamp + 1,
        ]
        try actual.update(from: finRow)
        let expected = MHistory(transactionID: "1", accountID: "b", securityID: "c", lotID: "z", shareCount: 7, sharePrice: 8, realizedGainShort: 9, realizedGainLong: 10, transactedAt: timestamp + 1)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MHistory(transactionID: " A-x?3 ", accountID: " -3B ! ", securityID: "  37 D302 ")
        let actual = element.primaryKey
        let expected = "a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MHistory.Row = ["transactionID": " A-x?3 ",
                                    "historyAccountID": " -3B ! ",
                                    "historySecurityID": "  37 D302 "]
        let actual = try MHistory.getPrimaryKey(finRow)
        let expected = "a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let YYYYMMDD = df.string(from: timestamp)
        let YYYYMMDDts = df.date(from: YYYYMMDD)
        let rawRows: [MHistory.RawRow] = [[
            "transactionID": "1",
            "historyAccountID": "a",
            "historySecurityID": "s",
            "historyLotID": "x",
            "shareCount": "3",
            "sharePrice": "4",
            "realizedGainShort": "5",
            "realizedGainLong": "6",
            "transactedAt": YYYYMMDD,
        ]]
        var rejected = [MHistory.Row]()
        let actual = try MHistory.decode(rawRows, rejectedRows: &rejected)
        let expected: MHistory.Row = [
            "transactionID": "1",
            "historyAccountID": "a",
            "historySecurityID": "s",
            "historyLotID": "x",
            "shareCount": 3,
            "sharePrice": 4,
            "realizedGainShort": 5,
            "realizedGainLong": 6,
            "transactedAt": YYYYMMDDts,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
