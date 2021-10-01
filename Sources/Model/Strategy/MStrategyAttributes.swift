//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MStrategy {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.strategyID, .string, isRequired: true, isKey: true, "The name of the strategy."),
        AllocAttribute(CodingKeys.title, .string, isRequired: false, isKey: false, "The title of the strategy."),
    ]
}
