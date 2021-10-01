//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MValuationSnapshot {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.snapshotID, .string, isRequired: true, isKey: true, "The unique valuation snapshot identifier."),
        AllocAttribute(CodingKeys.capturedAt, .date, isRequired: true, isKey: false, "The timestamp when the snapshot was created."),
    ]
}
