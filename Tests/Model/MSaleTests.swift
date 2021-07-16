//
//  MSaleTests.swift
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

class MSaleTests: XCTestCase {

    func testSchema() {
        let expected = AllocSchema.allocSale
        let actual = MSale.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MSale(accountID: "1", securityID: "BND", lotID: "3", amount: 17, shareCount: 3, liquidateAll: true)
        var actual = MSale(accountID: "1", securityID: "BND", lotID: "3", amount: 17)
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
        let expected = MSale(accountID: "1", securityID: "BND", lotID: "3", amount: 17, shareCount: 3, liquidateAll: true)
        let actual = try MSale(from: [
            MSale.CodingKeys.accountID.rawValue: "1",
            MSale.CodingKeys.securityID.rawValue: "BND",
            MSale.CodingKeys.lotID.rawValue: "3",
            MSale.CodingKeys.amount.rawValue: 17,
            MSale.CodingKeys.shareCount.rawValue: 3,
            MSale.CodingKeys.liquidateAll.rawValue: true,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MSale(accountID: "1", securityID: "BND", lotID: "3", amount: 17, shareCount: 3, liquidateAll: true)
        let finRow: MSale.Row = [
            MSale.CodingKeys.accountID.rawValue: "x", // IGNORED
            MSale.CodingKeys.securityID.rawValue: "xx", // IGNORED
            MSale.CodingKeys.lotID.rawValue: "xxx", // IGNORED
            MSale.CodingKeys.amount.rawValue: 23,
            MSale.CodingKeys.shareCount.rawValue: 5,
            MSale.CodingKeys.liquidateAll.rawValue: false,
        ]
        try actual.update(from: finRow)
        let expected = MSale(accountID: "1", securityID: "BND", lotID: "3", amount: 23, shareCount: 5, liquidateAll: false)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MSale(accountID: " A-x?3 ", securityID: " -3B ! ", lotID: "   ", amount: 17)
        let actual = element.primaryKey
        let expected = "a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MSale.Row = ["saleAccountID": " A-x?3 ", "saleSecurityID": " -3B ! ", "saleLotID": "   "]
        let actual = try MSale.getPrimaryKey(finRow)
        let expected = "a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MSale.RawRow] = [[
            "saleAccountID": "1",
            "saleSecurityID": "BND",
            "saleLotID": "3",
            "amount": "23",
            "shareCount": "4",
            "liquidateAll": "true",
        ]]
        var rejected = [MSale.Row]()
        let actual = try MSale.decode(rawRows, rejectedRows: &rejected)
        let expected: MSale.Row = [
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
