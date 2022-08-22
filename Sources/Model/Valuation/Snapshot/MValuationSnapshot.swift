//
//  MValuationSnapshot.swift
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

import Foundation

public struct MValuationSnapshot: Hashable & AllocBase {
    public var snapshotID: String // key
    public var capturedAt: Date

    public static var schema: AllocSchema { .allocValuationSnapshot }

    public init(
        snapshotID: String,
        capturedAt: Date
    ) {
        self.snapshotID = snapshotID
        self.capturedAt = capturedAt
    }
}

extension MValuationSnapshot: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case snapshotID = "valuationSnapshotID"
        case capturedAt
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        snapshotID = try c.decode(String.self, forKey: .snapshotID)
        capturedAt = try c.decode(Date.self, forKey: .capturedAt)
    }
}

extension MValuationSnapshot: CustomStringConvertible {
    public var description: String {
        let formattedDate = MValuationSnapshot.unparseDate(capturedAt)
        return "snapshotID=\(snapshotID) capturedAt=\(formattedDate)"
    }
}
