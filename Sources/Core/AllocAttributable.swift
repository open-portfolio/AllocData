//
//  AllocAttributable.swift
//
// Copyright 2021, 2022 OpenAlloc LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

public protocol AllocAttributable {
    static var attributes: [AllocAttribute] { get }
}

public struct AllocAttribute {
    public enum AttributeTypes {
        case string
        case double
        case int
        case bool
        case date
    }

    public init(_ codingKey: CodingKey, _ type: AttributeTypes, isRequired: Bool, isKey: Bool, _ descript: String) {
        self.codingKey = codingKey
        self.type = type
        self.isRequired = isRequired
        self.isKey = isKey
        self.descript = descript
    }

    public let codingKey: CodingKey
    public let type: AttributeTypes
    public let isRequired: Bool
    public let isKey: Bool
    public let descript: String

    public static func getSignature(_ attributes: [AllocAttribute]) -> AllocSchema.TableSignature {
        let codingkeys = attributes.filter(\.isRequired).map(\.codingKey)
        return AllocSchema.generateSignature(codingkeys)
    }

    public static func getHeaders(_ attributes: [AllocAttribute]) -> [String] {
        attributes.map(\.codingKey).map(\.stringValue)
    }
}

extension AllocAttribute: CustomStringConvertible {
    public var description: String {
        "\(codingKey.stringValue): type=\(type) required=\(isRequired) key=\(isKey) desc='\(descript)'"
    }
}
