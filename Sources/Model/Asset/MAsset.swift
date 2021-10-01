//
//  MAsset.swift
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

import Foundation

public struct MAsset: Hashable & AllocBase {
    public var assetID: String // key
    public var title: String?
    public var colorCode: Int?
    public var parentAssetID: String

    public static var schema: AllocSchema { .allocAsset }

    public init(assetID: String,
                title: String? = nil,
                colorCode: Int? = nil,
                parentAssetID: String? = nil)
    {
        self.assetID = assetID
        self.title = title
        self.colorCode = colorCode
        self.parentAssetID = parentAssetID ?? MAsset.AllocNilKey
    }
}

extension MAsset: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case assetID
        case title
        case colorCode
        case parentAssetID
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        assetID = try c.decode(String.self, forKey: .assetID)
        title = try c.decodeIfPresent(String.self, forKey: .title)
        colorCode = try c.decodeIfPresent(Int.self, forKey: .colorCode)
        parentAssetID = try c.decodeIfPresent(String.self, forKey: .parentAssetID) ?? MAsset.AllocNilKey
    }
}

extension MAsset: CustomStringConvertible {
    public var description: String {
        "assetID=\(assetID) title=\(String(describing: title)) colorCode=\(String(describing: colorCode)) parentAssetID=\(parentAssetID)"
    }
}
