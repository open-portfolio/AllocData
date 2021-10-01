//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MAsset: AllocBaseKey {
    public var primaryKey: AllocKey {
        MAsset.keyify(assetID)
    }
}
