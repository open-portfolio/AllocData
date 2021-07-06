//
//  FINformatTests.swift
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

class FINformatTests: XCTestCase {
    func testGuessJSON() {
        for ext in ["json", "JSON", "Json"] {
            let actual = AllocFormat.guess(fromFileExtension: ext)
            XCTAssertEqual(AllocFormat.JSON, actual)
        }
    }

    func testGuessCSV() {
        for ext in ["csv", "CSV", "Csv"] {
            let actual = AllocFormat.guess(fromFileExtension: ext)
            XCTAssertEqual(AllocFormat.CSV, actual)
        }
    }

    func testGuessTSV() {
        for ext in ["tsv", "TSV", "Tsv"] {
            let actual = AllocFormat.guess(fromFileExtension: ext)
            XCTAssertEqual(AllocFormat.TSV, actual)
        }
    }

    func testGuessNoLeadingDot() {
        XCTAssertNil(AllocFormat.guess(fromFileExtension: ".json"))
        XCTAssertNil(AllocFormat.guess(fromFileExtension: ".tsv"))
        XCTAssertNil(AllocFormat.guess(fromFileExtension: ".csv"))
    }
}
