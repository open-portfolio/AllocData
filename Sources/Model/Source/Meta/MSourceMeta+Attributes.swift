//
//  M+Attributes.swift
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

extension MSourceMeta: AllocAttributable {
    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.sourceMetaID, .string, isRequired: true, isKey: true, "The unique ID of the source meta record."),
        AllocAttribute(CodingKeys.url, .string, isRequired: false, isKey: false, "The source URL, if any."),
        AllocAttribute(CodingKeys.importerID, .string, isRequired: false, isKey: false, "The id of the importer/transformer, if any."),
        AllocAttribute(CodingKeys.exportedAt, .date, isRequired: false, isKey: false, "The published export date of the source data, if any."),
    ]
}
