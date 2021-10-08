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

extension MValuationAccount: AllocKeyed {
    public struct Key: Hashable, Equatable {
        public let snapshotNormID: String
        public let accountNormID: String
        
        public init(snapshotID: String, accountID: String) {
            self.snapshotNormID = MValuationAccount.normalizeID(snapshotID)
            self.accountNormID = MValuationAccount.normalizeID(accountID)
        }
        
        public init(_ element: MValuationAccount) {
            self.init(snapshotID: element.snapshotID, accountID: element.accountID)
        }
    }
    
    public var primaryKey: Key {
        Key(self)
    }
}

//extension MValuationAccount: AllocKeyed1 {
//    public var primaryKey1: AllocKey {
//        MValuationAccount.makePrimaryKey(snapshotID: snapshotID, accountID: accountID)
//    }
//
//    public static func makePrimaryKey(snapshotID: String, accountID: String) -> AllocKey {
//        keyify([snapshotID, accountID])
//    }
//}
