//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MValuationPosition: AllocBaseKey {
    public var primaryKey: AllocKey {
        MValuationPosition.makePrimaryKey(snapshotID: snapshotID, accountID: accountID, assetID: assetID)
    }

    public static func makePrimaryKey(snapshotID: String, accountID: String, assetID: String) -> AllocKey {
        keyify([snapshotID, accountID, assetID])
    }
}
