//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MSecurity: AllocBaseKey {
    public var primaryKey: AllocKey {
        MSecurity.keyify(securityID)
    }
}
