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

extension MValuationSnapshot: AllocAttributable {
    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.snapshotID, .string, isRequired: true, isKey: true, "The unique valuation snapshot identifier."),
        AllocAttribute(CodingKeys.capturedAt, .date, isRequired: true, isKey: false, "The timestamp when the snapshot was created."),
    ]
}
