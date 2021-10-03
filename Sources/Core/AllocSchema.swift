//
//  AllocSchema.swift
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

public enum AllocSchema: String, CaseIterable {
    case allocStrategy = "openalloc/strategy"
    case allocAllocation = "openalloc/allocation"
    case allocAsset = "openalloc/asset"
    case allocHolding = "openalloc/holding"
    case allocAccount = "openalloc/account"
    case allocSecurity = "openalloc/security"
    case allocTransaction = "openalloc/transaction"
    case allocCap = "openalloc/cap"
    case allocTracker = "openalloc/tracker"
    case allocRebalanceSale = "openalloc/rebalance/sale"
    case allocRebalancePurchase = "openalloc/rebalance/purchase"
    case allocRebalanceAllocation = "openalloc/rebalance/allocation"
    case allocValuationSnapshot = "openalloc/valuation/snapshot"
    case allocValuationAccount = "openalloc/valuation/account"
    case allocValuationPosition = "openalloc/valuation/position"
    case allocValuationCashflow = "openalloc/valuation/cashflow"
    case allocMetaSource = "openalloc/meta/source"
    // add other supported tabular schema cases here

    public var attributes: [AllocAttribute] {
        switch self {
        case .allocStrategy:
            return MStrategy.attributes
        case .allocAllocation:
            return MAllocation.attributes
        case .allocAsset:
            return MAsset.attributes
        case .allocHolding:
            return MHolding.attributes
        case .allocAccount:
            return MAccount.attributes
        case .allocSecurity:
            return MSecurity.attributes
        case .allocTransaction:
            return MTransaction.attributes
        case .allocCap:
            return MCap.attributes
        case .allocTracker:
            return MTracker.attributes
        case .allocRebalanceSale:
            return MRebalanceSale.attributes
        case .allocRebalancePurchase:
            return MRebalancePurchase.attributes
        case .allocRebalanceAllocation:
            return MRebalanceAllocation.attributes
        case .allocValuationSnapshot:
            return MValuationSnapshot.attributes
        case .allocValuationAccount:
            return MValuationAccount.attributes
        case .allocValuationPosition:
            return MValuationPosition.attributes
        case .allocValuationCashflow:
            return MValuationCashflow.attributes
        case .allocMetaSource:
            return MSourceMeta.attributes
        }
    }
}
