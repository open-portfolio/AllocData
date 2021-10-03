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

extension MSecurity: AllocAttributable {
    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The symbol/securityID of the security."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: false, isKey: false, "The asset class of the security."),
        AllocAttribute(CodingKeys.sharePrice, .double, isRequired: false, isKey: false, "The reported price of one share of the security."),
        AllocAttribute(CodingKeys.updatedAt, .date, isRequired: false, isKey: false, "The timestamp of the the reported price."),
        AllocAttribute(CodingKeys.trackerID, .string, isRequired: false, isKey: false, "The index the security is tracking."),
    ]
}
