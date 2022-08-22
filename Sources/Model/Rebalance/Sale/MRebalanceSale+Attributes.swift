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

extension MRebalanceSale: AllocAttributable {
    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account hosting the position."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security of the position."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the position, if any."),
        AllocAttribute(CodingKeys.amount, .double, isRequired: true, isKey: false, "The amount in dollars to liquidate from this position."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: false, isKey: false, "Estimated number of shares to liquidate from this position."),
        AllocAttribute(CodingKeys.liquidateAll, .bool, isRequired: false, isKey: false, "If true, the entire position can be liquidated."),
    ]
}
