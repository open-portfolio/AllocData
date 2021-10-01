//
//  File.swift
//
//
//  Created by Reed Esau on 9/30/21.
//

import Foundation

public protocol AllocRow {
    // pre-decoded row, without strong typing
    typealias RawRow = [String: String]

    // decoded row, with strong typing
    typealias DecodedRow = [String: AnyHashable?]

    // create object from row
    init(from row: DecodedRow) throws

    static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow]

    // additive update from row
    mutating func update(from row: DecodedRow) throws

    static func getPrimaryKey(_ row: DecodedRow) throws -> AllocKey
}
