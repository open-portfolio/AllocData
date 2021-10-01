//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public extension MSourceMeta {
    static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.sourceMetaID, .string, isRequired: true, isKey: true, "The unique ID of the source meta record."),
        AllocAttribute(CodingKeys.url, .string, isRequired: false, isKey: false, "The source URL, if any."),
        AllocAttribute(CodingKeys.importerID, .string, isRequired: false, isKey: false, "The id of the importer/transformer, if any."),
        AllocAttribute(CodingKeys.exportedAt, .date, isRequired: false, isKey: false, "The published export date of the source data, if any."),
    ]
}
