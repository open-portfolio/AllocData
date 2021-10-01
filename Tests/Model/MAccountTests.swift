//
//  MAccountTests.swift
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

class MAccountTests: XCTestCase {
    func testSchema() {
        let expected = AllocSchema.allocAccount
        let actual = MAccount.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MAccount(accountID: "a", title: "b", isActive: true, isTaxable: true, canTrade: true, strategyID: "X")
        var actual = MAccount(accountID: "a")
        XCTAssertNil(actual.title)
        XCTAssertFalse(actual.isActive)
        XCTAssertFalse(actual.isTaxable)
        XCTAssertFalse(actual.canTrade)
        XCTAssertEqual("", actual.strategyID)
        actual.title = "b"
        actual.isActive = true
        actual.isTaxable = true
        actual.canTrade = true
        actual.strategyID = "X"
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MAccount(accountID: "a", title: "b", isActive: true, isTaxable: true, canTrade: true, strategyID: "X")
        let actual = try MAccount(from: [
            MAccount.CodingKeys.accountID.rawValue: "a",
            MAccount.CodingKeys.title.rawValue: "b",
            MAccount.CodingKeys.isActive.rawValue: true,
            MAccount.CodingKeys.isTaxable.rawValue: true,
            MAccount.CodingKeys.canTrade.rawValue: true,
            MAccount.CodingKeys.strategyID.rawValue: "X",
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MAccount(accountID: "a", title: "b", isActive: false, isTaxable: false, canTrade: false, strategyID: "X")
        let finRow: MAccount.DecodedRow = [
            MAccount.CodingKeys.accountID.rawValue: "c", // IGNORED
            MAccount.CodingKeys.title.rawValue: "e",
            MAccount.CodingKeys.isActive.rawValue: true,
            MAccount.CodingKeys.isTaxable.rawValue: true,
            MAccount.CodingKeys.canTrade.rawValue: true,
            MAccount.CodingKeys.strategyID.rawValue: "C",
        ]
        try actual.update(from: finRow)
        let expected = MAccount(accountID: "a", title: "e", isActive: true, isTaxable: true, canTrade: true, strategyID: "C")
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let account = MAccount(accountID: " A-x?3 ")
        let actual = account.primaryKey
        let expected = "a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MAccount.DecodedRow = ["accountID": " A-x?3 "]
        let actual = try MAccount.getPrimaryKey(finRow)
        let expected = "a-x?3"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MAccount.RawRow] = [[
            "accountID": "a",
            "title": "b",
            "isActive": "true",
            "isTaxable": "true",
            "canTrade": "true",
            "accountStrategyID": "X",
        ]]
        var rejected = [MAccount.RawRow]()
        let actual = try MAccount.decode(rawRows, rejectedRows: &rejected)
        let expected: MAccount.DecodedRow = [
            "accountID": "a",
            "title": "b",
            "isActive": true,
            "isTaxable": true,
            "canTrade": true,
            "accountStrategyID": "X",
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }

    func testDecodeUpperBool() throws {
        let rawRows: [MAccount.RawRow] = [[
            "accountID": "a",
            "title": "b",
            "isActive": "TRUE",
            "isTaxable": "TRUE",
            "canTrade": "TRUE",
        ]]
        var rejected = [MAccount.RawRow]()
        let actual = try MAccount.decode(rawRows, rejectedRows: &rejected)
        let expected: MAccount.DecodedRow = [
            "accountID": "a",
            "title": "b",
            "isActive": true,
            "isTaxable": true,
            "canTrade": true,
            "accountStrategyID": "",
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
