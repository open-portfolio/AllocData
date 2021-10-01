//
//  MTransaction+Action.swift
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

public extension MTransaction {
    enum Action: String, Codable, CaseIterable {
        
        /// purchase/sale of security to/from cash; aka conversion
        /// scope: local to account
        /// shareCount: <0 is a sale; >0 is a purchase
        /// sharePrice: >0, price per share
        /// security: required
        case buysell
                
        /// income from interest, or the dividend of a stock/etf/etc.
        /// scope: local to account
        /// shareCount: amount of income
        /// sharePrice: 1.0
        /// security: if dividend
        case income
        
        /// transfer of security/cash to/from external source
        /// shareCount: <0 is outgoing; >0 is incoming
        /// sharePrice: 1.0 if cash; >0 for security
        /// security: if not cash
        case transfer
        
        /// neutral (non-income) cashflow in account
        /// shareCount: <0 is outgoing; >0 is incoming
        /// sharePrice: 1.0
        /// security: none
        case misc
    }
}
