//
//  MHoldingTests.swift
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

class MHoldingTests: XCTestCase {
    lazy var timestamp = Date()

    func testSchema() {
        let expected = AllocSchema.allocHolding
        let actual = MHolding.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MHolding(accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, shareBasis: 4, acquiredAt: timestamp)
        var actual = MHolding(accountID: "1", securityID: "BND", lotID: "3")
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("BND", actual.securityID)
        XCTAssertEqual("3", actual.lotID)
        XCTAssertNil(actual.shareCount)
        XCTAssertNil(actual.shareBasis)
        XCTAssertNil(actual.acquiredAt)
        actual.shareCount = 3
        actual.shareBasis = 4
        actual.acquiredAt = timestamp
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MHolding(accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, shareBasis: 4, acquiredAt: timestamp)
        let actual = try MHolding(from: [
            MHolding.CodingKeys.accountID.rawValue: "1",
            MHolding.CodingKeys.securityID.rawValue: "BND",
            MHolding.CodingKeys.lotID.rawValue: "3",
            MHolding.CodingKeys.shareCount.rawValue: 3,
            MHolding.CodingKeys.shareBasis.rawValue: 4,
            MHolding.CodingKeys.acquiredAt.rawValue: timestamp,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MHolding(accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, shareBasis: 4, acquiredAt: timestamp)
        let finRow: MHolding.Row = [
            MHolding.CodingKeys.accountID.rawValue: "x", // IGNORED
            MHolding.CodingKeys.securityID.rawValue: "xx", // IGNORED
            MHolding.CodingKeys.lotID.rawValue: "xxx", // IGNORED
            MHolding.CodingKeys.shareCount.rawValue: 5,
            MHolding.CodingKeys.shareBasis.rawValue: 6,
            MHolding.CodingKeys.acquiredAt.rawValue: timestamp + 1,
        ]
        try actual.update(from: finRow)
        let expected = MHolding(accountID: "1", securityID: "BND", lotID: "3", shareCount: 5, shareBasis: 6, acquiredAt: timestamp + 1)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MHolding(accountID: " A-x?3 ", securityID: " -3B ! ", lotID: "   ")
        let actual = element.primaryKey
        let expected = "a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MHolding.Row = ["holdingAccountID": " A-x?3 ", "holdingSecurityID": " -3B ! ", "holdingLotID": "   "]
        let actual = try MHolding.getPrimaryKey(finRow)
        let expected = "a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let YYYYMMDD = Date.formatYYYYMMDD(timestamp) ?? ""
        let YYYYMMDDts = MHolding.parseYYYYMMDD(YYYYMMDD)
        let rawRows: [MHolding.RawRow] = [[
            "holdingAccountID": "1",
            "holdingSecurityID": "BND",
            "holdingLotID": "3",
            "shareCount": "4",
            "shareBasis": "5",
            "acquiredAt": YYYYMMDD,
        ]]
        var rejected = [MHolding.Row]()
        let actual = try MHolding.decode(rawRows, rejectedRows: &rejected)
        let expected: MHolding.Row = [
            "holdingAccountID": "1",
            "holdingSecurityID": "BND",
            "holdingLotID": "3",
            "shareCount": 4,
            "shareBasis": 5,
            "acquiredAt": YYYYMMDDts,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
