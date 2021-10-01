//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MAllocation: AllocBaseKey {
    public var primaryKey: AllocKey {
        MAllocation.keyify([strategyID, assetID])
    }
}
