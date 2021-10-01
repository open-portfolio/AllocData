//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MValuationSnapshot: AllocBaseKey {
    public var primaryKey: AllocKey {
        MValuationSnapshot.makePrimaryKey(snapshotID: snapshotID)
    }

    public static func makePrimaryKey(snapshotID: String) -> AllocKey {
        keyify(snapshotID)
    }
}
