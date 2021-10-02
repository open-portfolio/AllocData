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
