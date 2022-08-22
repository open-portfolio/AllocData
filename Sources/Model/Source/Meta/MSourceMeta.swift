//
//  AllocProperty.swift
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

public struct MSourceMeta: Hashable & AllocBase {
    public var sourceMetaID: String // key
    public var url: URL?
    public var importerID: String?
    public var exportedAt: Date?

    public static var schema: AllocSchema { .allocMetaSource }

    public init(sourceMetaID: String,
                url: URL? = nil,
                importerID: String? = nil,
                exportedAt: Date? = nil)
    {
        self.sourceMetaID = sourceMetaID
        self.url = url
        self.importerID = importerID
        self.exportedAt = exportedAt
    }
}

extension MSourceMeta: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case sourceMetaID
        case url
        case importerID
        case exportedAt
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        sourceMetaID = try c.decode(String.self, forKey: .sourceMetaID)
        url = try c.decodeIfPresent(URL.self, forKey: .url)
        importerID = try c.decodeIfPresent(String.self, forKey: .importerID)
        exportedAt = try c.decodeIfPresent(Date.self, forKey: .exportedAt)
    }
}

extension MSourceMeta: CustomStringConvertible {
    public var description: String {
        "sourceMetaID=\(sourceMetaID) url=\(String(describing: url)) importerID=\(String(describing: importerID)) exportedAt=\(String(describing: exportedAt))"
    }
}
