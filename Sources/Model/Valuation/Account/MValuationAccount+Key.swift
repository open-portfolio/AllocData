//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MValuationAccount: AllocBaseKey {
    public var primaryKey: AllocKey {
        MValuationAccount.makePrimaryKey(snapshotID: snapshotID, accountID: accountID)
    }

    public static func makePrimaryKey(snapshotID: String, accountID: String) -> AllocKey {
        keyify([snapshotID, accountID])
    }
}
