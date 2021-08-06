//
//  MValuationPositionTests.swift
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

class MValuationPositionTests: XCTestCase {
    let timestamp = Date()

    func testSchema() {
        let expected = AllocSchema.allocValuationPosition
        let actual = MValuationPosition.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        let expected = MValuationPosition(snapshotID: beg.snapshotID, accountID: "1", securityID: "BND", lotID: "3", shareBasis: 24, shareCount: 23, sharePrice: 25, assetID: "ITGov")
        var actual = MValuationPosition(snapshotID: beg.snapshotID, accountID: "1", securityID: "BND", lotID: "3", shareBasis: 4, shareCount: 3, sharePrice: 5, assetID: "Bond")
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("BND", actual.securityID)
        XCTAssertEqual("3", actual.lotID)
        XCTAssertEqual(4, actual.shareBasis)
        XCTAssertEqual(3, actual.shareCount)
        XCTAssertEqual(5, actual.sharePrice)
        XCTAssertEqual("Bond", actual.assetID)
        actual.shareBasis = 24
        actual.shareCount = 23
        actual.sharePrice = 25
        actual.assetID = "ITGov"
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        let expected = MValuationPosition(snapshotID: beg.snapshotID, accountID: "1", securityID: "BND", lotID: "3", shareBasis: 4, shareCount: 3, sharePrice: 5, assetID: "Bond")
        let actual = try MValuationPosition(from: [
            MValuationPosition.CodingKeys.snapshotID.rawValue: "B",
            MValuationPosition.CodingKeys.accountID.rawValue: "1",
            MValuationPosition.CodingKeys.securityID.rawValue: "BND",
            MValuationPosition.CodingKeys.lotID.rawValue: "3",
            MValuationPosition.CodingKeys.shareBasis.rawValue: 4,
            MValuationPosition.CodingKeys.shareCount.rawValue: 3,
            MValuationPosition.CodingKeys.sharePrice.rawValue: 5,
            MValuationPosition.CodingKeys.assetID.rawValue: "Bond",
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        var actual = MValuationPosition(snapshotID: beg.snapshotID, accountID: "1", securityID: "BND", lotID: "3", shareBasis: 4, shareCount: 3, sharePrice: 5, assetID: "ITGov")
        let finRow: MValuationPosition.Row = [
            MValuationPosition.CodingKeys.snapshotID.rawValue: "Z", // IGNORED
            MValuationPosition.CodingKeys.accountID.rawValue: "x", // IGNORED
            MValuationPosition.CodingKeys.securityID.rawValue: "xx", // IGNORED
            MValuationPosition.CodingKeys.lotID.rawValue: "xxx", // IGNORED
            MValuationPosition.CodingKeys.shareBasis.rawValue: 24,
            MValuationPosition.CodingKeys.shareCount.rawValue: 23,
            MValuationPosition.CodingKeys.sharePrice.rawValue: 25,
            MValuationPosition.CodingKeys.assetID.rawValue: "Bond",
        ]
        try actual.update(from: finRow)
        let expected = MValuationPosition(snapshotID: beg.snapshotID, accountID: "1", securityID: "BND", lotID: "3", shareBasis: 24, shareCount: 23, sharePrice: 25, assetID: "Bond")
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        let element = MValuationPosition(snapshotID: beg.snapshotID, accountID: " A-x?3 ", securityID: " -3B ! ", lotID: "   ", shareBasis: 4, shareCount: 3, sharePrice: 5, assetID: "Bond")
        let actual = element.primaryKey
        let expected = "b,a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MValuationPosition.Row = [
            "valuationPositionSnapshotID": " B  ",
            "valuationPositionAccountID": " A-x?3 ",
            "valuationPositionSecurityID": " -3B ! ",
            "valuationPositionLotID": "   ",
        ]
        let actual = try MValuationPosition.getPrimaryKey(finRow)
        let expected = "b,a-x?3,-3b !,"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MValuationPosition.RawRow] = [[
            "valuationPositionSnapshotID": "B",
            "valuationPositionAccountID": "1",
            "valuationPositionSecurityID": "BND",
            "valuationPositionLotID": "3",
            "shareBasis": "5",
            "shareCount": "9",
            "sharePrice": "7",
            "assetID": "Bond",
        ]]
        var rejected = [MValuationPosition.Row]()
        let actual = try MValuationPosition.decode(rawRows, rejectedRows: &rejected)
        let expected: MValuationPosition.Row = [
            "valuationPositionSnapshotID": "B",
            "valuationPositionAccountID": "1",
            "valuationPositionSecurityID": "BND",
            "valuationPositionLotID": "3",
            "shareBasis": 5,
            "shareCount": 9,
            "sharePrice": 7,
            "assetID": "Bond",
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
