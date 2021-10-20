//
//  M+Attributes.swift
//
// Copyright 2021 FlowAllocator LLC
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

extension MAsset: AllocAttributable {
    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The identifier of the asset. (e.g., 'Bond')"),
        AllocAttribute(CodingKeys.title, .string, isRequired: false, isKey: false, "The title of the asset."),
        AllocAttribute(CodingKeys.colorCode, .int, isRequired: false, isKey: false, "The code for the asset's color palette."),
        AllocAttribute(CodingKeys.parentAssetID, .string, isRequired: false, isKey: false, "The id of the parent of the asset."),
    ]
}
