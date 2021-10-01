//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MRebalanceAllocation: AllocBaseKey {
    public var primaryKey: AllocKey {
        MRebalanceAllocation.keyify([accountID, assetID])
    }
}
