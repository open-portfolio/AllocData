//
//  MSourceMetaTests.swift
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

class MSourceMetaTests: XCTestCase {
    lazy var timestamp = Date()
    lazy var df = ISO8601DateFormatter()

    func testSchema() {
        let expected = AllocSchema.allocMetaSource
        let actual = MSourceMeta.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MSourceMeta(sourceMetaID: "1", url: URL(string: "http://blah.com"), importerID: "blech", exportedAt: timestamp + 1)
        var actual = MSourceMeta(sourceMetaID: "1")
        XCTAssertEqual("1", actual.sourceMetaID)
        XCTAssertNil(actual.url)
        XCTAssertNil(actual.importerID)
        XCTAssertNil(actual.exportedAt)
        actual.url = URL(string: "http://blah.com")
        actual.importerID = "blech"
        actual.exportedAt = timestamp + 1
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MSourceMeta(sourceMetaID: "1", url: URL(string: "http://blah.com"), importerID: "blech", exportedAt: timestamp)
        let actual = try MSourceMeta(from: [
            MSourceMeta.CodingKeys.sourceMetaID.rawValue: "1",
            MSourceMeta.CodingKeys.url.rawValue: URL(string: "http://blah.com"),
            MSourceMeta.CodingKeys.importerID.rawValue: "blech",
            MSourceMeta.CodingKeys.exportedAt.rawValue: timestamp,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MSourceMeta(sourceMetaID: "1", url: URL(string: "http://blah.com"), importerID: "blech", exportedAt: timestamp)
        let finRow: MSourceMeta.DecodedRow = [
            MSourceMeta.CodingKeys.sourceMetaID.rawValue: "x", // IGNORED
            MSourceMeta.CodingKeys.url.rawValue: URL(string: "http://blort.com"),
            MSourceMeta.CodingKeys.importerID.rawValue: "bloop",
            MSourceMeta.CodingKeys.exportedAt.rawValue: timestamp + 1,
        ]
        try actual.update(from: finRow)
        let expected = MSourceMeta(sourceMetaID: "1", url: URL(string: "http://blort.com"), importerID: "bloop", exportedAt: timestamp + 1)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MSourceMeta(sourceMetaID: " A-x?3 ")
        let actual = element.primaryKey
        let expected = "a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MSourceMeta.DecodedRow = ["sourceMetaID": " A-x?3 "]
        let actual = try MSourceMeta.getPrimaryKey(finRow)
        let expected = "a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let YYYYMMDD = df.string(from: timestamp)
        let YYYYMMDDts = df.date(from: YYYYMMDD)!
        let rawRows: [MSourceMeta.RawRow] = [[
            "sourceMetaID": "1",
            "url": "http://blah.com",
            "importerID": "blech",
            "exportedAt": YYYYMMDD,
        ]]
        var rejected = [MSourceMeta.RawRow]()
        let actual = try MSourceMeta.decode(rawRows, rejectedRows: &rejected)
        let expected: MSourceMeta.DecodedRow = [
            "sourceMetaID": "1",
            "url": URL(string: "http://blah.com")!,
            "importerID": "blech",
            "exportedAt": YYYYMMDDts,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
