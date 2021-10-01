//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MAccount: AllocBaseKey {
    public var primaryKey: AllocKey {
        MAccount.keyify(accountID)
    }
}
