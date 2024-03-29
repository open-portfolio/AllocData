//
//  MAllocation+Key.swift
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

extension MAllocation: Identifiable {
    public var id: MAllocation.Key { primaryKey }
}

extension MAllocation: AllocKeyed {
    public struct Key: Hashable, Equatable, Codable {
        public let strategyNormID: NormalizedID
        public let assetNormID: NormalizedID

        public init(strategyID: String, assetID: String) {
            strategyNormID = MAllocation.normalizeID(strategyID)
            assetNormID = MAllocation.normalizeID(assetID)
        }

        public init(_ element: MAllocation) {
            self.init(strategyID: element.strategyID, assetID: element.assetID)
        }
    }

    public var primaryKey: Key {
        Key(self)
    }

    public static var emptyKey: Key {
        Key(strategyID: "", assetID: "")
    }
}
