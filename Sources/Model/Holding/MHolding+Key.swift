//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MHolding: AllocBaseKey {
    public var primaryKey: AllocKey {
        MHolding.keyify([accountID, securityID, lotID])
    }
}
