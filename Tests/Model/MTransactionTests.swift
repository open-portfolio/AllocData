//
//  MTransactionTests.swift
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

class MTransactionTests: XCTestCase {
    lazy var timestamp = Date()
    lazy var df = ISO8601DateFormatter()

    func testSchema() {
        let expected = AllocSchema.allocTransaction
        let actual = MTransaction.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MTransaction(action: .income, transactedAt: timestamp, accountID: "a", securityID: "s", lotID: "x", shareCount: 3, sharePrice: 4, realizedGainShort: 5, realizedGainLong: 6)
        var actual = MTransaction(action: .buysell, transactedAt: timestamp, accountID: "a", securityID: "s", lotID: "x")
        XCTAssertEqual(MTransaction.Action.buysell, actual.action)
        XCTAssertEqual(timestamp, actual.transactedAt)
        XCTAssertEqual("a", actual.accountID)
        XCTAssertEqual("s", actual.securityID)
        XCTAssertEqual("x", actual.lotID)
        XCTAssertEqual(0.0, actual.shareCount)
        XCTAssertEqual(0.0, actual.sharePrice)
        XCTAssertNil(actual.realizedGainShort)
        XCTAssertNil(actual.realizedGainLong)
        actual.action = .income
        actual.shareCount = 3
        actual.sharePrice = 4
        actual.realizedGainShort = 5
        actual.realizedGainLong = 6
        actual.transactedAt = timestamp
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MTransaction(action: .income, transactedAt: timestamp, accountID: "a", securityID: "s", lotID: "x", shareCount: 3, sharePrice: 4, realizedGainShort: 5, realizedGainLong: 6)
        let actual = try MTransaction(from: [
            MTransaction.CodingKeys.action.rawValue: MTransaction.Action.income,
            MTransaction.CodingKeys.transactedAt.rawValue: timestamp,
            MTransaction.CodingKeys.accountID.rawValue: "a",
            MTransaction.CodingKeys.securityID.rawValue: "s",
            MTransaction.CodingKeys.lotID.rawValue: "x",
            MTransaction.CodingKeys.shareCount.rawValue: 3,
            MTransaction.CodingKeys.sharePrice.rawValue: 4,
            MTransaction.CodingKeys.realizedGainShort.rawValue: 5,
            MTransaction.CodingKeys.realizedGainLong.rawValue: 6,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MTransaction(action: .buysell, transactedAt: timestamp, accountID: "b", securityID: "c", lotID: "z", shareCount: 3, sharePrice: 4, realizedGainShort: 5, realizedGainLong: 6)
        let finRow: MTransaction.DecodedRow = [
            MTransaction.CodingKeys.action.rawValue: MTransaction.Action.miscflow, // IGNORED
            MTransaction.CodingKeys.transactedAt.rawValue: timestamp + 200, // IGNORED
            MTransaction.CodingKeys.accountID.rawValue: "bx", // IGNORED
            MTransaction.CodingKeys.securityID.rawValue: "cx", // IGNORED
            MTransaction.CodingKeys.lotID.rawValue: "zx", // IGNORED
            MTransaction.CodingKeys.shareCount.rawValue: 7, // IGNORED
            MTransaction.CodingKeys.sharePrice.rawValue: 8, // IGNORED
            MTransaction.CodingKeys.realizedGainShort.rawValue: 9,
            MTransaction.CodingKeys.realizedGainLong.rawValue: 10,
        ]
        try actual.update(from: finRow)
        let expected = MTransaction(action: .buysell, transactedAt: timestamp, accountID: "b", securityID: "c", lotID: "z", shareCount: 3, sharePrice: 4, realizedGainShort: 9, realizedGainLong: 10)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MTransaction(action: .buysell, transactedAt: timestamp, accountID: " A-x?3 ", securityID: " -3B ! ", lotID: " fo/ ", shareCount: 3, sharePrice: 4)
        let actual = element.primaryKey
        let expected = MTransaction.Key(action: .buysell, transactedAt: timestamp, accountID: " A-x?3 ", securityID: " -3B ! ", lotID: " fo/ ", shareCount: 3, sharePrice: 4)
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MTransaction.DecodedRow = [
            "txnAction": MTransaction.Action.miscflow,
            "txnTransactedAt": timestamp,
            "txnAccountID": " A-x?3 ",
            "txnSecurityID": " -3B ! ",
            "txnLotID": " fo/ ",
            "txnShareCount": 3,
            "txnSharePrice": 4,
        ]
        let actual = try MTransaction.getPrimaryKey(finRow)
        let expected = MTransaction.Key(action: .miscflow, transactedAt: timestamp, accountID: " A-x?3 ", securityID: " -3B ! ", lotID: " fo/ ", shareCount: 3, sharePrice: 4)
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let YYYYMMDD = df.string(from: timestamp)
        let YYYYMMDDts = df.date(from: YYYYMMDD)!
        let rawRows: [MTransaction.RawRow] = [[
            "txnAction": "transfer",
            "txnTransactedAt": YYYYMMDD,
            "txnAccountID": "a",
            "txnSecurityID": "s",
            "txnLotID": "x",
            "txnShareCount": "3",
            "txnSharePrice": "4",
            "realizedGainShort": "5",
            "realizedGainLong": "6",
        ]]
        var rejected = [MTransaction.RawRow]()
        let actual = try MTransaction.decode(rawRows, rejectedRows: &rejected)
        let expected: MTransaction.DecodedRow = [
            "txnAction": MTransaction.Action.transfer,
            "txnTransactedAt": YYYYMMDDts,
            "txnAccountID": "a",
            "txnSecurityID": "s",
            "txnLotID": "x",
            "txnShareCount": 3,
            "txnSharePrice": 4,
            "realizedGainShort": 5,
            "realizedGainLong": 6,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
    
    // ensure gains are omitted from encoding if nil
    func testEncodeWithoutGains() throws {
        let datetime1 = df.date(from: "2021-03-01T17:00:00Z")!
        let element = MTransaction(action: .buysell, transactedAt: datetime1, accountID: "1", securityID: "2", lotID: "", shareCount: 3, sharePrice: 4)
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(element)
        let actual = String(data: jsonData, encoding: .utf8)
        let expected = "{\"txnAction\":\"buysell\",\"realizedGainShort\":null,\"txnShareCount\":3,\"txnSecurityID\":\"2\",\"realizedGainLong\":null,\"txnAccountID\":\"1\",\"txnSharePrice\":4,\"txnTransactedAt\":636310800,\"txnLotID\":\"\"}"
        XCTAssertEqual(expected, actual)
    }
}
