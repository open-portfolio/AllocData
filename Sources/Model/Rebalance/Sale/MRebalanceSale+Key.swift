//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MRebalanceSale: AllocBaseKey {
    public var primaryKey: AllocKey {
        MRebalanceSale.keyify([accountID, securityID, lotID])
    }
}
