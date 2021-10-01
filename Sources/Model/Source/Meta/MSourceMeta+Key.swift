//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MSourceMeta: AllocBaseKey {
    public var primaryKey: AllocKey {
        MSourceMeta.keyify(sourceMetaID)
    }
}
