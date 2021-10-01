//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

extension MTracker: AllocBaseKey {
    public var primaryKey: AllocKey {
        MTracker.keyify(trackerID)
    }
}
