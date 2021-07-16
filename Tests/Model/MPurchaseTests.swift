//
//  MPurchaseTests.swift
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

class MPurchaseTests: XCTestCase {

    func testSchema() {
        let expected = AllocSchema.allocPurchase
        let actual = MPurchase.schema
        XCTAssertEqual(expected, actual)
    }

    func testInit() {
        let expected = MPurchase(accountID: "1", assetID: "Bond", amount: 5)
        var actual = MPurchase(accountID: "1", assetID: "Bond", amount: 3)
        XCTAssertEqual("1", actual.accountID)
        XCTAssertEqual("Bond", actual.assetID)
        XCTAssertEqual(3, actual.amount)
        actual.amount = 5
        XCTAssertEqual(expected, actual)
    }

    func testInitFromFINrow() throws {
        let expected = MPurchase(accountID: "1", assetID: "Bond", amount: 3)
        let actual = try MPurchase(from: [
            MPurchase.CodingKeys.accountID.rawValue: "1",
            MPurchase.CodingKeys.assetID.rawValue: "Bond",
            MPurchase.CodingKeys.amount.rawValue: 3,
        ])
        XCTAssertEqual(expected, actual)
    }

    func testUpdateFromFINrow() throws {
        var actual = MPurchase(accountID: "1", assetID: "Bond", amount: 3)
        let finRow: MPurchase.Row = [
            MPurchase.CodingKeys.accountID.rawValue: "x", // IGNORED
            MPurchase.CodingKeys.assetID.rawValue: "xx", // IGNORED
            MPurchase.CodingKeys.amount.rawValue: 5,
        ]
        try actual.update(from: finRow)
        let expected = MPurchase(accountID: "1", assetID: "Bond", amount: 5)
        XCTAssertEqual(expected, actual)
    }

    func testPrimaryKey() throws {
        let element = MPurchase(accountID: " A-x?3 ", assetID: " -3B ! ", amount: 10)
        let actual = element.primaryKey
        let expected = "a-x?3,-3b !"
        XCTAssertEqual(expected, actual)
    }

    func testGetPrimaryKey() throws {
        let finRow: MPurchase.Row = ["purchaseAccountID": " A-x?3 ", "purchaseAssetID": " -3B ! "]
        let actual = try MPurchase.getPrimaryKey(finRow)
        let expected = "a-x?3,-3b !"
        XCTAssertEqual(expected, actual)
    }

    func testDecode() throws {
        let rawRows: [MPurchase.RawRow] = [[
            "purchaseAccountID": "1",
            "purchaseAssetID": "Bond",
            "amount": "4",
        ]]
        var rejected = [MPurchase.Row]()
        let actual = try MPurchase.decode(rawRows, rejectedRows: &rejected)
        let expected: MPurchase.Row = [
            "purchaseAccountID": "1",
            "purchaseAssetID": "Bond",
            "amount": 4,
        ]
        XCTAssertTrue(rejected.isEmpty)
        XCTAssertEqual([expected], actual)
    }
}
