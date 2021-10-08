//
//  MAssetTests.swift
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

class MAssetTests: XCTestCase {
    func testSchema() {
        let expected = AllocSchema.allocAsset
        let actual = MAsset.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MAsset(assetID: "a", title: "b", colorCode: 7, parentAssetID: "TM")
        var actual = MAsset(assetID: "a")
        XCTAssertNil(actual.title)
        XCTAssertNil(actual.colorCode)
        XCTAssertTrue(actual.parentAssetID.isEmpty)
        actual.title = "b"
        actual.colorCode = 7
        actual.parentAssetID = "TM"
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MAsset(assetID: "a", title: "b", colorCode: 7, parentAssetID: "TM")
        let actual = try MAsset(from: [
            MAsset.CodingKeys.assetID.rawValue: "a",
            MAsset.CodingKeys.title.rawValue: "b",
            MAsset.CodingKeys.colorCode.rawValue: 7,
            MAsset.CodingKeys.parentAssetID.rawValue: "TM",
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MAsset(assetID: "a", title: "b", colorCode: nil, parentAssetID: nil)
        let finRow: MAsset.DecodedRow = [
            MAsset.CodingKeys.assetID.rawValue: "c", // IGNORED
            MAsset.CodingKeys.title.rawValue: "e",
            MAsset.CodingKeys.colorCode.rawValue: 7,
            MAsset.CodingKeys.parentAssetID.rawValue: "TM",
        ]
        try actual.update(from: finRow)
        let expected = MAsset(assetID: "a", title: "e", colorCode: 7, parentAssetID: "TM")
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let asset = MAsset(assetID: " A-x?3 ")
        let actual = asset.primaryKey
        let expected = MAsset.Key(assetID: " A-x?3 ")
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MAsset.DecodedRow = ["assetID": " A-x?3 "]
        let actual = try MAsset.getPrimaryKey(finRow)
        let expected = MAsset.Key(assetID: " A-x?3 ")
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MAsset.RawRow] = [[
            "assetID": "a",
            "title": "b",
            "colorCode": "7",
            "parentAssetID": "TM",
        ]]
        var rejected = [MAsset.RawRow]()
        let actual = try MAsset.decode(rawRows, rejectedRows: &rejected)
        let expected: MAsset.DecodedRow = [
            "assetID": "a",
            "title": "b",
            "colorCode": 7,
            "parentAssetID": "TM",
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
