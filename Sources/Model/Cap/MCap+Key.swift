//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MCap: AllocBaseKey {
    public var primaryKey: AllocKey {
        MCap.keyify([accountID, assetID])
    }
}
