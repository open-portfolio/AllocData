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

extension MValuationPosition: AllocAttributable {
    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.snapshotID, .string, isRequired: true, isKey: true, "The valuation snapshot ID for the position."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account hosting the position."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset class of the position."),
        AllocAttribute(CodingKeys.totalBasis, .double, isRequired: true, isKey: false, "The price paid to establish position."),
        AllocAttribute(CodingKeys.marketValue, .double, isRequired: true, isKey: false, "The market value of the position."),
    ]
}
