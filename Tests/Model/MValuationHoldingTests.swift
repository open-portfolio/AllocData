//
//  MValuationHoldingTests.swift
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

class MValuationHoldingTests: XCTestCase {
    lazy var timestamp = Date()
    lazy var df = ISO8601DateFormatter()

    func testSchema() {
        let expected = AllocSchema.allocValuationHolding
        let actual = MValuationHolding.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MValuationHolding(snapshotID: "X", accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, shareBasis: 4)
        var actual = MValuationHolding(snapshotID: "X", accountID: "1", securityID: "BND", lotID: "3")
        XCTAssertEqual("X", actual.snapshotID)
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("BND", actual.securityID)
        XCTAssertEqual("3", actual.lotID)
        XCTAssertNil(actual.shareCount)
        XCTAssertNil(actual.shareBasis)
        actual.shareCount = 3
        actual.shareBasis = 4
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MValuationHolding(snapshotID: "X", accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, shareBasis: 4)
        let actual = try MValuationHolding(from: [
            MValuationHolding.CodingKeys.snapshotID.rawValue: "X",
            MValuationHolding.CodingKeys.accountID.rawValue: "1",
            MValuationHolding.CodingKeys.securityID.rawValue: "BND",
            MValuationHolding.CodingKeys.lotID.rawValue: "3",
            MValuationHolding.CodingKeys.shareCount.rawValue: 3,
            MValuationHolding.CodingKeys.shareBasis.rawValue: 4,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MValuationHolding(snapshotID: "X", accountID: "1", securityID: "BND", lotID: "3", shareCount: 3, shareBasis: 4)
        let finRow: MValuationHolding.Row = [
            MValuationHolding.CodingKeys.snapshotID.rawValue: "zzz", // IGNORED
            MValuationHolding.CodingKeys.accountID.rawValue: "x", // IGNORED
            MValuationHolding.CodingKeys.securityID.rawValue: "xx", // IGNORED
            MValuationHolding.CodingKeys.lotID.rawValue: "xxx", // IGNORED
            MValuationHolding.CodingKeys.shareCount.rawValue: 5,
            MValuationHolding.CodingKeys.shareBasis.rawValue: 6,
        ]
        try actual.update(from: finRow)
        let expected = MValuationHolding(snapshotID: "X", accountID: "1", securityID: "BND", lotID: "3", shareCount: 5, shareBasis: 6)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MValuationHolding(snapshotID: "   X  ", accountID: " A-x?3 ", securityID: " -3B ! ", lotID: "   ")
        let actual = element.primaryKey
        let expected = "x,a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MValuationHolding.Row = ["valuationHoldingSnapshotID": "  XX  ",
                                             "valuationHoldingAccountID": " A-x?3 ",
                                             "valuationHoldingSecurityID": " -3B ! ",
                                             "valuationHoldingLotID": "   "]
        let actual = try MValuationHolding.getPrimaryKey(finRow)
        let expected = "xx,a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MValuationHolding.RawRow] = [[
            "valuationHoldingSnapshotID": "X",
            "valuationHoldingAccountID": "1",
            "valuationHoldingSecurityID": "BND",
            "valuationHoldingLotID": "3",
            "shareCount": "4",
            "shareBasis": "5",
        ]]
        var rejected = [MValuationHolding.Row]()
        let actual = try MValuationHolding.decode(rawRows, rejectedRows: &rejected)
        let expected: MValuationHolding.Row = [
            "valuationHoldingSnapshotID": "X",
            "valuationHoldingAccountID": "1",
            "valuationHoldingSecurityID": "BND",
            "valuationHoldingLotID": "3",
            "shareCount": 4,
            "shareBasis": 5,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
