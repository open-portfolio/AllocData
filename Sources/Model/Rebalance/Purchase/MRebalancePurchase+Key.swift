//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MRebalancePurchase: AllocBaseKey {
    public var primaryKey: AllocKey {
        MRebalancePurchase.keyify([accountID, assetID])
    }
}
