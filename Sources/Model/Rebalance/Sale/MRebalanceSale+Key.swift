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
    public struct Key: Hashable, Equatable, Codable {
        public let accountNormID: NormalizedID
        public let securityNormID: NormalizedID
        public let lotNormID: NormalizedID
        
        public init(accountID: String, securityID: String, lotID: String) {
            self.accountNormID = MRebalanceSale.normalizeID(accountID)
            self.securityNormID = MRebalanceSale.normalizeID(securityID)
            self.lotNormID = MRebalanceSale.normalizeID(lotID)
        }
        
        public init(_ element: MRebalanceSale) {
            self.init(accountID: element.accountID,
                      securityID: element.securityID,
                      lotID: element.lotID)
        }
    }
    
    public var primaryKey: Key {
        Key(self)
    }
    
    public static var emptyKey: Key {
        Key(accountID: "", securityID: "", lotID: "")
    }
}
