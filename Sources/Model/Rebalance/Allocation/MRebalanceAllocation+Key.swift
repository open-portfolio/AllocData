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

extension MRebalanceAllocation: AllocKeyed {
    public struct Key: Hashable, Comparable, Equatable {
        private let accountIDn: String
        private let assetIDn: String
        
        internal init(accountID: String, assetID: String) {
            self.accountIDn = MRebalanceAllocation.normalizeID(accountID)
            self.assetIDn = MRebalanceAllocation.normalizeID(assetID)
        }
        
        public init(_ element: MRebalanceAllocation) {
            self.init(accountID: element.accountID,
                      assetID: element.assetID)
        }
        
        public static func < (lhs: Key, rhs: Key) -> Bool {
            if lhs.accountIDn < rhs.accountIDn { return true }
            if lhs.accountIDn > rhs.accountIDn { return false }

            if lhs.assetIDn < rhs.assetIDn { return true }
            if lhs.assetIDn > rhs.assetIDn { return false }
            
            return false
        }
    }
    
    public var primaryKey: Key {
        Key(self)
    }
}

//extension MRebalanceAllocation: AllocKeyed1 {
//    public var primaryKey1: AllocKey {
//        MRebalanceAllocation.keyify([accountID, assetID])
//    }
//}
