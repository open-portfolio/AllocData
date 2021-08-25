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
        let expected = MValuationPosition(snapshotID: beg.snapshotID, accountID: "1", assetID: "Bond", totalBasis: 24*23, marketValue: 25*23)
        var actual = MValuationPosition(snapshotID: beg.snapshotID, accountID: "1", assetID: "ITGov", totalBasis: 4*3, marketValue: 5*3)
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("ITGov", actual.assetID)
        XCTAssertEqual(12, actual.totalBasis)
        XCTAssertEqual(15, actual.marketValue)
        actual.totalBasis = 24*23
        actual.marketValue = 25*23
        actual.assetID = "Bond"
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        let expected = MValuationPosition(snapshotID: beg.snapshotID, accountID: "1", assetID: "Bond", totalBasis: 4, marketValue: 3)
        let actual = try MValuationPosition(from: [
            MValuationPosition.CodingKeys.snapshotID.rawValue: "B",
            MValuationPosition.CodingKeys.accountID.rawValue: "1",
            MValuationPosition.CodingKeys.totalBasis.rawValue: 4,
            MValuationPosition.CodingKeys.marketValue.rawValue: 3,
            MValuationPosition.CodingKeys.assetID.rawValue: "Bond",
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        var actual = MValuationPosition(snapshotID: beg.snapshotID, accountID: "1", assetID: "Bond", totalBasis: 4, marketValue: 3)
        let finRow: MValuationPosition.Row = [
            MValuationPosition.CodingKeys.snapshotID.rawValue: "Z", // IGNORED
            MValuationPosition.CodingKeys.accountID.rawValue: "x", // IGNORED
            MValuationPosition.CodingKeys.assetID.rawValue: "Bond", // IGNORED
            MValuationPosition.CodingKeys.totalBasis.rawValue: 24,
            MValuationPosition.CodingKeys.marketValue.rawValue: 23,
        ]
        try actual.update(from: finRow)
        let expected = MValuationPosition(snapshotID: beg.snapshotID, accountID: "1", assetID: "Bond", totalBasis: 24, marketValue: 23)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let beg = MValuationSnapshot(snapshotID: "B", capturedAt: timestamp)
        let element = MValuationPosition(snapshotID: beg.snapshotID, accountID: " A-x?3 ", assetID: " -3B ! ", totalBasis: 4, marketValue: 3)
        let actual = element.primaryKey
        let expected = "b,a-x?3,-3b !"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MValuationPosition.Row = [
            "valuationPositionSnapshotID": " B  ",
            "valuationPositionAccountID": " A-x?3 ",
            "valuationPositionAssetID": " -3B ! ",
        ]
        let actual = try MValuationPosition.getPrimaryKey(finRow)
        let expected = "b,a-x?3,-3b !"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MValuationPosition.RawRow] = [[
            "valuationPositionSnapshotID": "B",
            "valuationPositionAccountID": "1",
            "valuationPositionAssetID": "Bond",
            "totalBasis": "5",
            "marketValue": "9",
        ]]
        var rejected = [MValuationPosition.Row]()
        let actual = try MValuationPosition.decode(rawRows, rejectedRows: &rejected)
        let expected: MValuationPosition.Row = [
            "valuationPositionSnapshotID": "B",
            "valuationPositionAccountID": "1",
            "valuationPositionAssetID": "Bond",
            "totalBasis": 5,
            "marketValue": 9,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
