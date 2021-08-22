//
//  MSecurityTests.swift
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

class MSecurityTests: XCTestCase {
    lazy var timestamp = Date()
    lazy var df = ISO8601DateFormatter()

    func testSchema() {
        let expected = AllocSchema.allocSecurity
        let actual = MSecurity.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MSecurity(securityID: "BND", assetID: "Bond", sharePrice: 0.77, updatedAt: timestamp, trackerID: "3")
        var actual = MSecurity(securityID: "BND", assetID: "Bond")
        XCTAssertEqual("BND", actual.securityID)
        XCTAssertEqual("Bond", actual.assetID)
        XCTAssertNil(actual.sharePrice)
        XCTAssertNil(actual.updatedAt)
        XCTAssertEqual(AllocNilKey, actual.trackerID)
        actual.sharePrice = 0.77
        actual.updatedAt = timestamp
        actual.trackerID = "3"
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MSecurity(securityID: "BND", assetID: "Bond", sharePrice: 0.77, updatedAt: timestamp, trackerID: "3")
        let actual = try MSecurity(from: [
            MSecurity.CodingKeys.securityID.rawValue: "BND",
            MSecurity.CodingKeys.assetID.rawValue: "Bond",
            MSecurity.CodingKeys.sharePrice.rawValue: 0.77,
            MSecurity.CodingKeys.updatedAt.rawValue: timestamp,
            MSecurity.CodingKeys.trackerID.rawValue: "3",
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MSecurity(securityID: "BND", assetID: "Bond", sharePrice: 0.77, updatedAt: timestamp, trackerID: "3")
        let finRow: MSecurity.Row = [
            MSecurity.CodingKeys.securityID.rawValue: "x", // IGNORED
            MSecurity.CodingKeys.assetID.rawValue: "Equities",
            MSecurity.CodingKeys.sharePrice.rawValue: 0.88,
            MSecurity.CodingKeys.updatedAt.rawValue: timestamp + 1,
            MSecurity.CodingKeys.trackerID.rawValue: "4",
        ]
        try actual.update(from: finRow)
        let expected = MSecurity(securityID: "BND", assetID: "Equities", sharePrice: 0.88, updatedAt: timestamp + 1, trackerID: "4")
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MSecurity(securityID: " A-x?3 ", assetID: " -3B ! ")
        let actual = element.primaryKey
        let expected = "a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MSecurity.Row = ["securityID": " A-x?3 ", "securityAssetID": " -3B ! "]
        let actual = try MSecurity.getPrimaryKey(finRow)
        let expected = "a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let YYYYMMDD = df.string(from: timestamp)
        let YYYYMMDDts = df.date(from: YYYYMMDD)
        let rawRows: [MSecurity.RawRow] = [[
            "securityID": "BND",
            "securityAssetID": "Bond",
            "sharePrice": "0.77",
            "updatedAt": YYYYMMDD,
            "securityTrackerID": "3",
        ]]
        var rejected = [MSecurity.Row]()
        let actual = try MSecurity.decode(rawRows, rejectedRows: &rejected)
        let expected: MSecurity.Row = [
            "securityID": "BND",
            "securityAssetID": "Bond",
            "sharePrice": 0.77,
            "updatedAt": YYYYMMDDts,
            "securityTrackerID": "3",
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
