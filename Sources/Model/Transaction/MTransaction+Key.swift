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

extension MTransaction: AllocKeyed {
    public struct Key: Hashable, Equatable, Codable {
        public let action: Action
        public let transactedAt: Date
        public let accountNormID: NormalizedID
        public let securityNormID: NormalizedID
        public let lotNormID: NormalizedID
        public let shareCount: Double
        public let sharePrice: Double
        
        public init(action: Action,
             transactedAt: Date,
             accountID: String,
             securityID: String,
             lotID: String,
             shareCount: Double,
             sharePrice: Double) {
            self.action = action
            self.transactedAt = transactedAt
            self.accountNormID = MTransaction.normalizeID(accountID)
            self.securityNormID = MTransaction.normalizeID(securityID)
            self.lotNormID = MTransaction.normalizeID(lotID)
            self.shareCount = shareCount
            self.sharePrice = sharePrice
        }

        public init(_ element: MTransaction) {
            self.init(action: element.action,
                      transactedAt: element.transactedAt,
                      accountID: element.accountID,
                      securityID: element.securityID,
                      lotID: element.lotID,
                      shareCount: element.shareCount,
                      sharePrice: element.sharePrice)
        }
    }
    
    public var primaryKey: Key {
        Key(self)
    }
    
    public static var emptyKey: Key {
        Key(action: .miscflow, transactedAt: Date.init(timeIntervalSinceReferenceDate: 0), accountID: "", securityID: "", lotID: "", shareCount: 0, sharePrice: 0)
    }
}
