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

extension MRebalanceSale: AllocKeyed {
    public struct Key: Hashable, Comparable, Equatable {
        private let accountIDn: String
        private let securityIDn: String
        private let lotIDn: String
        
        internal init(accountID: String, securityID: String, lotID: String) {
            self.accountIDn = MRebalanceSale.normalizeID(accountID)
            self.securityIDn = MRebalanceSale.normalizeID(securityID)
            self.lotIDn = MRebalanceSale.normalizeID(lotID)
        }
        
        public init(_ element: MRebalanceSale) {
            self.init(accountID: element.accountID,
                      securityID: element.securityID,
                      lotID: element.lotID)
        }
        
        public static func < (lhs: Key, rhs: Key) -> Bool {
            if lhs.accountIDn < rhs.accountIDn { return true }
            if lhs.accountIDn > rhs.accountIDn { return false }

            if lhs.securityIDn < rhs.securityIDn { return true }
            if lhs.securityIDn > rhs.securityIDn { return false }
            
            if lhs.lotIDn < rhs.lotIDn { return true }
            if lhs.lotIDn > rhs.lotIDn { return false }

            return false
        }
    }
    
    public var primaryKey: Key {
        Key(self)
    }
}

//extension MRebalanceSale: AllocKeyed1 {
//    public var primaryKey1: AllocKey {
//        MRebalanceSale.keyify([accountID, securityID, lotID])
//    }
//}
