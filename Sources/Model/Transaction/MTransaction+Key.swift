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

extension MTransaction: AllocKeyed2 {
    public struct Key: Hashable, Comparable, Equatable {
        private let action: Action
        private let transactedAt: Date
        private let accountIDn: String
        private let securityIDn: String
        private let lotIDn: String
        private let shareCount: Double
        private let sharePrice: Double
        
        init(_ element: MTransaction) {
            self.action = element.action
            self.transactedAt = element.transactedAt
            self.accountIDn = MTransaction.normalizeID(element.accountID)
            self.securityIDn = MTransaction.normalizeID(element.securityID)
            self.lotIDn = MTransaction.normalizeID(element.lotID)
            self.shareCount = element.shareCount
            self.sharePrice = element.sharePrice
        }
        
        public static func < (lhs: Key, rhs: Key) -> Bool {
            if lhs.transactedAt < rhs.transactedAt { return true }
            if lhs.transactedAt > rhs.transactedAt { return false }

            if lhs.accountIDn < rhs.accountIDn { return true }
            if lhs.accountIDn > rhs.accountIDn { return false }

            if lhs.securityIDn < rhs.securityIDn { return true }
            if lhs.securityIDn > rhs.securityIDn { return false }

            if lhs.shareCount < rhs.shareCount { return true }
            if lhs.shareCount > rhs.shareCount { return false }

            if lhs.sharePrice < rhs.sharePrice { return true }
            if lhs.sharePrice > rhs.sharePrice { return false }
            return false
        }
    }
    
    public var primaryKey2: Key {
        Key(self)
    }
}

extension MTransaction: AllocKeyed {
    public var primaryKey: AllocKey {
        MTransaction.makePrimaryKey(action: action,
                                    transactedAt: transactedAt,
                                    accountID: accountID,
                                    securityID: securityID,
                                    lotID: lotID,
                                    shareCount: shareCount,
                                    sharePrice: sharePrice)
    }

    public static func makePrimaryKey(action: Action,
                                      transactedAt: Date,
                                      accountID: String,
                                      securityID: String,
                                      lotID: String,
                                      shareCount: Double,
                                      sharePrice: Double) -> AllocKey
    {
        // NOTE: using time interval in composite key as ISO dates will vary.

        // This implementation can change at ANY time and may differ per platform.
        // Because of that AllocData keys should NOT be persisted in data files
        // or across executions. If you need to store a date, use the ISO format.

        let formattedAction = action.rawValue
        let refEpoch = transactedAt.timeIntervalSinceReferenceDate
        let formattedDate = String(format: "%010.0f", refEpoch)
        let formattedShareCount = String(format: "%.4f", shareCount)
        let formattedSharePrice = String(format: "%.2f", sharePrice) // BUGFIX: Schwab gain/loss exports rounding to nearest penny
        return keyify([formattedAction, formattedDate, accountID, securityID, lotID, formattedShareCount, formattedSharePrice])
    }
}
