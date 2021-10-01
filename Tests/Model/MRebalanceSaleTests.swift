//
//  MRebalanceSaleTests.swift
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

class MRebalanceSaleTests: XCTestCase {
    func testSchema() {
        let expected = AllocSchema.allocRebalanceSale
        let actual = MRebalanceSale.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MRebalanceSale(accountID: "1", securityID: "BND", lotID: "3", amount: 17, shareCount: 3, liquidateAll: true)
        var actual = MRebalanceSale(accountID: "1", securityID: "BND", lotID: "3", amount: 17)
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("BND", actual.securityID)
        XCTAssertEqual("3", actual.lotID)
        XCTAssertEqual(17, actual.amount)
        XCTAssertNil(actual.shareCount)
        XCTAssertFalse(actual.liquidateAll)
        actual.shareCount = 3
        actual.liquidateAll = true
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MRebalanceSale(accountID: "1", securityID: "BND", lotID: "3", amount: 17, shareCount: 3, liquidateAll: true)
        let actual = try MRebalanceSale(from: [
            MRebalanceSale.CodingKeys.accountID.rawValue: "1",
            MRebalanceSale.CodingKeys.securityID.rawValue: "BND",
            MRebalanceSale.CodingKeys.lotID.rawValue: "3",
            MRebalanceSale.CodingKeys.amount.rawValue: 17,
            MRebalanceSale.CodingKeys.shareCount.rawValue: 3,
            MRebalanceSale.CodingKeys.liquidateAll.rawValue: true,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MRebalanceSale(accountID: "1", securityID: "BND", lotID: "3", amount: 17, shareCount: 3, liquidateAll: true)
        let finRow: MRebalanceSale.DecodedRow = [
            MRebalanceSale.CodingKeys.accountID.rawValue: "x", // IGNORED
            MRebalanceSale.CodingKeys.securityID.rawValue: "xx", // IGNORED
            MRebalanceSale.CodingKeys.lotID.rawValue: "xxx", // IGNORED
            MRebalanceSale.CodingKeys.amount.rawValue: 23,
            MRebalanceSale.CodingKeys.shareCount.rawValue: 5,
            MRebalanceSale.CodingKeys.liquidateAll.rawValue: false,
        ]
        try actual.update(from: finRow)
        let expected = MRebalanceSale(accountID: "1", securityID: "BND", lotID: "3", amount: 23, shareCount: 5, liquidateAll: false)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MRebalanceSale(accountID: " A-x?3 ", securityID: " -3B ! ", lotID: "   ", amount: 17)
        let actual = element.primaryKey
        let expected = "a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MRebalanceSale.DecodedRow = ["saleAccountID": " A-x?3 ", "saleSecurityID": " -3B ! ", "saleLotID": "   "]
        let actual = try MRebalanceSale.getPrimaryKey(finRow)
        let expected = "a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MRebalanceSale.RawRow] = [[
            "saleAccountID": "1",
            "saleSecurityID": "BND",
            "saleLotID": "3",
            "amount": "23",
            "shareCount": "4",
            "liquidateAll": "true",
        ]]
        var rejected = [MRebalanceSale.RawRow]()
        let actual = try MRebalanceSale.decode(rawRows, rejectedRows: &rejected)
        let expected: MRebalanceSale.DecodedRow = [
            "saleAccountID": "1",
            "saleSecurityID": "BND",
            "saleLotID": "3",
            "amount": 23,
            "shareCount": 4,
            "liquidateAll": true,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
