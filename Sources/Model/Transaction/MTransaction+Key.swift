//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MTransaction: AllocBaseKey {
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
        let formattedSharePrice = String(format: "%.4f", sharePrice)
        return keyify([formattedAction, formattedDate, accountID, securityID, lotID, formattedShareCount, formattedSharePrice])
    }
}
