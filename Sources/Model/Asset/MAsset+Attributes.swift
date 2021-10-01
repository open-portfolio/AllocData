//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MAsset {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The id of the asset."),
        AllocAttribute(CodingKeys.title, .string, isRequired: false, isKey: false, "The title of the asset."),
        AllocAttribute(CodingKeys.colorCode, .int, isRequired: false, isKey: false, "The code for the asset's color palette."),
        AllocAttribute(CodingKeys.parentAssetID, .string, isRequired: false, isKey: false, "The id of the parent of the asset."),
    ]
}
