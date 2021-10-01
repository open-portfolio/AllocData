//
//  AllocTracker.swift
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

public struct MTracker: Hashable & AllocBase {
    public var trackerID: String // key
    public var title: String?

    public static var schema: AllocSchema { .allocTracker }

    public init(trackerID: String,
                title: String? = nil)
    {
        self.trackerID = trackerID
        self.title = title
    }
}

extension MTracker: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case trackerID
        case title
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        trackerID = try c.decode(String.self, forKey: .trackerID)
        title = try c.decodeIfPresent(String.self, forKey: .title)
    }
}

extension MTracker: CustomStringConvertible {
    public var description: String {
        "trackerID=\(trackerID) title=\(String(describing: title))"
    }
}
