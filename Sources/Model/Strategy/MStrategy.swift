//
//  AllocStrategy.swift
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

public struct MStrategy: Hashable & AllocBase {
    public var strategyID: String // key
    public var title: String?

    public static var schema: AllocSchema { .allocStrategy }

    public init(strategyID: String,
                title: String? = nil)
    {
        self.strategyID = strategyID
        self.title = title
    }
}

extension MStrategy: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case strategyID
        case title
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        strategyID = try c.decode(String.self, forKey: .strategyID)
        title = try c.decodeIfPresent(String.self, forKey: .title)
    }
}

extension MStrategy: CustomStringConvertible {
    public var description: String {
        "strategyID=\(strategyID) title=\(String(describing: title))"
    }
}
