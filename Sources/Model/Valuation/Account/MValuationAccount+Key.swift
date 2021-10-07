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

extension MValuationAccount: AllocKeyed2 {
    public struct Key: Hashable, Comparable, Equatable {
        private let snapshotIDn: String
        private let accountIDn: String
        
        init(_ element: MValuationAccount) {
            self.snapshotIDn = MValuationAccount.normalizeID(element.snapshotID)
            self.accountIDn = MValuationAccount.normalizeID(element.accountID)
        }
        
        public static func < (lhs: Key, rhs: Key) -> Bool {
            if lhs.snapshotIDn < rhs.snapshotIDn { return true }
            if lhs.snapshotIDn > rhs.snapshotIDn { return false }

            if lhs.accountIDn < rhs.accountIDn { return true }
            if lhs.accountIDn > rhs.accountIDn { return false }

            return false
        }
    }
    
    public var primaryKey2: Key {
        Key(self)
    }
}

extension MValuationAccount: AllocKeyed {
    public var primaryKey: AllocKey {
        MValuationAccount.makePrimaryKey(snapshotID: snapshotID, accountID: accountID)
    }

    public static func makePrimaryKey(snapshotID: String, accountID: String) -> AllocKey {
        keyify([snapshotID, accountID])
    }
}
