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

extension MValuationCashflow: AllocAttributable {
    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.transactedAt, .date, isRequired: true, isKey: true, "The timestamp when this flow occurred."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account in which the flow occurred."),
        AllocAttribute(CodingKeys.assetID, .string, isRequired: true, isKey: true, "The asset class flowed."),
        AllocAttribute(CodingKeys.amount, .double, isRequired: true, isKey: false, "The amount of the flow (-Sale, +Purchase)."),
        AllocAttribute(CodingKeys.reconciled, .bool, isRequired: true, isKey: false, "If record was created to reconcile transactions."),
    ]
}
