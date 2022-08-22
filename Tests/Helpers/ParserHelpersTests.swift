//
//  ParserHelpersTests.swift
//
// Copyright 2021, 2022 OpenAlloc LLC
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

final class ParserHelpersTests: XCTestCase {
    func testParseEmpty() throws {
        let actual = MCap.parseDouble("")
        XCTAssertNil(actual)
    }

    func testParseBlank() throws {
        let actual = MCap.parseDouble("   ")
        XCTAssertNil(actual)
    }

    func testParseString() throws {
        let actual = MCap.parseDouble("n/a")
        XCTAssertNil(actual)
    }

    func testParseZero() throws {
        let expected = 0.0
        let actual = MCap.parseDouble("0")
        XCTAssertEqual(expected, actual)
    }

    func testNegativeZero() throws {
        let expected = 0.0
        let actual = MCap.parseDouble("-0")
        XCTAssertEqual(expected, actual)
    }

    func testParseZeroWithDecimalPoint() throws {
        let expected = 0.0
        let actual = MCap.parseDouble("0.")
        XCTAssertEqual(expected, actual)
    }

    func testParseNegativeZeroWithDecimalPoint() throws {
        let expected = 0.0
        let actual = MCap.parseDouble("-.000")
        XCTAssertEqual(expected, actual)
    }

    func testParseWithComma() throws {
        let expected = 11945.20
        let actual = MCap.parseDouble("+$11,945.20")
        XCTAssertEqual(expected, actual)
    }

    func testParseWithSpaces() throws {
        let expected = 11945.20
        let actual = MCap.parseDouble("   +$11,945.20    ")
        XCTAssertEqual(expected, actual)
    }

    func testParseNegative() throws {
        let expected = -11945.20
        let actual = MCap.parseDouble("-$11,945.20")
        XCTAssertEqual(expected, actual)
    }

    func testTwoDecimalPoints() throws {
        let actual = MCap.parseDouble("11.945.20")
        XCTAssertNil(actual)
    }

    func testTrailingNegative() throws {
        let actual = MCap.parseDouble("11945.20-")
        XCTAssertNil(actual)
    }

    func testEmbeddedNegative() throws {
        let actual = MCap.parseDouble("11945-20")
        XCTAssertNil(actual)
    }

    func testParsePercent() throws {
        let expected = -0.903
        let actual = MCap.parsePercent("-90.3%")
        XCTAssertEqual(expected, actual)
    }

    func testParsePercentWithSpaces() throws {
        let expected = -0.903
        let actual = MCap.parsePercent("    -90.3%    ")
        XCTAssertEqual(expected, actual)
    }

    func testParsePercentWithComma() throws {
        let expected = 10.003
        let actual = MCap.parsePercent("1,000.3%")
        XCTAssertEqual(expected, actual)
    }

    func testParsePercentWithNoSign() throws {
        let expected = -0.903
        let actual = MCap.parsePercent("-90.3")
        XCTAssertEqual(expected, actual)
    }

    func testParseBoolBlank() throws {
        let actual = MCap.parseBool("   ")
        XCTAssertNil(actual)
    }

    func testParseBoolEmpty() throws {
        let actual = MCap.parseBool("")
        XCTAssertNil(actual)
    }

    func testParseFalseLower() throws {
        let actual = MCap.parseBool("false")!
        XCTAssertFalse(actual)
    }

    func testParseFalseMixed() throws {
        let actual = MCap.parseBool("False")!
        XCTAssertFalse(actual)
    }

    func testParseFalseUpper() throws {
        let actual = MCap.parseBool("FALSE")!
        XCTAssertFalse(actual)
    }

    func testParseTrueLower() throws {
        let actual = MCap.parseBool("true")!
        XCTAssertTrue(actual)
    }

    func testParseTrueMixed() throws {
        let actual = MCap.parseBool("True")!
        XCTAssertTrue(actual)
    }

    func testParseTrueUpper() throws {
        let actual = MCap.parseBool("TRUE")!
        XCTAssertTrue(actual)
    }

    func testParseISOdate() throws {
        let df = ISO8601DateFormatter()
        let expected = df.date(from: "2012-12-31T19:00:00Z")
        let actual = MTransaction.parseDate("2012-12-31T19:00:00Z")!
        XCTAssertEqual(expected, actual)
    }

    func testParsePartialISOdate() throws {
        let df = ISO8601DateFormatter()
        let expected = df.date(from: "2012-12-31T00:00:00Z")
        let actual = MTransaction.parseDate("2012-12-31")!
        XCTAssertEqual(expected, actual)
    }
}
