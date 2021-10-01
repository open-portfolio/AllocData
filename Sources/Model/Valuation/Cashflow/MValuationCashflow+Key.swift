//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MValuationCashflow: AllocBaseKey {
    public var primaryKey: AllocKey {
        MValuationCashflow.makePrimaryKey(transactedAt: transactedAt, accountID: accountID, assetID: assetID)
    }

    public static func makePrimaryKey(transactedAt: Date, accountID: String, assetID: String) -> AllocKey {
        // NOTE: using time interval in composite key as ISO dates will vary.
        // This implementation can change at ANY time and may differ per platform.
        // Because of that AllocData keys should NOT be persisted in data files
        // or across executions. If you need to store a date, use the ISO format.

        let refEpoch = transactedAt.timeIntervalSinceReferenceDate
        let formattedDate = String(format: "%010.0f", refEpoch)
        return keyify([formattedDate, accountID, assetID])
    }
}
