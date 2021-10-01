//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MStrategy: AllocBaseKey {
    public var primaryKey: AllocKey {
        MStrategy.keyify(strategyID)
    }
}
