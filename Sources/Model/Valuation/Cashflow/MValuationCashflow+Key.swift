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

extension MValuationCashflow: AllocKeyed {
    public struct Key: Hashable, Comparable, Equatable {
        private let transactedAt: Date
        private let accountIDn: String
        private let assetIDn: String
        
        public init(transactedAt: Date, accountID: String, assetID: String) {
            self.transactedAt = transactedAt
            self.accountIDn = MTracker.normalizeID(accountID)
            self.assetIDn = MTracker.normalizeID(assetID)
        }
        
        public init(_ element: MValuationCashflow) {
            self.init(transactedAt: element.transactedAt,
                      accountID: element.accountID,
                      assetID: element.assetID)
        }
        
        public static func < (lhs: Key, rhs: Key) -> Bool {
            if lhs.transactedAt < rhs.transactedAt { return true }
            if lhs.transactedAt > rhs.transactedAt { return false }

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

//extension MValuationCashflow: AllocKeyed1 {
//    
////    internal struct Key: Hashable, Comparable, Equatable {
////        var transactedAt: Date
////        var accountID: String
////        var assetID: String
////        
////        public init(_ cashflow: MValuationCashflow) {
////            self.transactedAt = cashflow.transactedAt
////            self.accountID = cashflow.accountID.lowercased()
////            self.assetID = cashflow.assetID.lowercased()
////        }
////        
////        public static func < (lhs: Key, rhs: Key) -> Bool {
////            if lhs.transactedAt < rhs.transactedAt { return true }
////            if lhs.transactedAt > rhs.transactedAt { return false }
////
////            if lhs.accountID < rhs.accountID { return true }
////            if lhs.accountID > rhs.accountID { return false }
////
////            if lhs.assetID < rhs.assetID { return true }
////            if lhs.assetID > rhs.assetID { return false }
////
////            return false
////        }
////    }
//
//    public var primaryKey1: AllocKey {
//        MValuationCashflow.makePrimaryKey(transactedAt: transactedAt, accountID: accountID, assetID: assetID)
//    }
//
//    public static func makePrimaryKey(transactedAt: Date, accountID: String, assetID: String) -> AllocKey {
//        // NOTE: using time interval in composite key as ISO dates will vary.
//        // This implementation can change at ANY time and may differ per platform.
//        // Because of that AllocData keys should NOT be persisted in data files
//        // or across executions. If you need to store a date, use the ISO format.
//
//        let refEpoch = transactedAt.timeIntervalSinceReferenceDate
//        let formattedDate = String(format: "%010.0f", refEpoch)
//        return keyify([formattedDate, accountID, assetID])
//    }
//}
