//
//  MAsset+Key.swift
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

extension MAsset: Identifiable {
    public var id: MAsset.Key { primaryKey }
}

extension MAsset: AllocKeyed {
    public struct Key: Hashable, Equatable, Codable {
        public let assetNormID: NormalizedID

        public init(assetID: String) {
            assetNormID = MAsset.normalizeID(assetID)
        }

        public init(_ element: MAsset) {
            self.init(assetID: element.assetID)
        }
    }

    public var primaryKey: Key {
        Key(self)
    }

    public static var emptyKey: Key {
        Key(assetID: "")
    }
}
