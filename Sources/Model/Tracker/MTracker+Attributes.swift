//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MTracker {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.trackerID, .string, isRequired: true, isKey: true, "The name of the tracking index."),
        AllocAttribute(CodingKeys.title, .string, isRequired: false, isKey: false, "The title of the tracking index."),
    ]
}
