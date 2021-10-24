//
//  M+Key.swift
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

extension MValuationPosition: AllocKeyed {
    public struct Key: Hashable, Equatable, Codable {
        public let snapshotNormID: NormalizedID
        public let accountNormID: NormalizedID
        public let assetNormID: NormalizedID
        
        public init(snapshotID: String, accountID: String, assetID: String) {
            self.snapshotNormID = MValuationPosition.normalizeID(snapshotID)
            self.accountNormID = MValuationPosition.normalizeID(accountID)
            self.assetNormID = MValuationPosition.normalizeID(assetID)
        }
        
        public init(_ element: MValuationPosition) {
            self.init(snapshotID: element.snapshotID,
                      accountID: element.accountID,
                      assetID: element.assetID)
        }
    }
    
    public var primaryKey: Key {
        Key(self)
    }
    
    public static var emptyKey: Key {
        Key(snapshotID: "", accountID: "", assetID: "")
    }
}
