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

extension MTransaction: AllocAttributable {
    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.action, .string, isRequired: true, isKey: true, "The type of transaction."),
        AllocAttribute(CodingKeys.transactedAt, .date, isRequired: true, isKey: true, "The date of the transaction."),
        AllocAttribute(CodingKeys.accountID, .string, isRequired: true, isKey: true, "The account in which the transaction occurred."),
        AllocAttribute(CodingKeys.securityID, .string, isRequired: true, isKey: true, "The security involved in the transaction."),
        AllocAttribute(CodingKeys.lotID, .string, isRequired: true, isKey: true, "The lot of the position involved in the transaction (blank if none)."),
        AllocAttribute(CodingKeys.shareCount, .double, isRequired: true, isKey: true, "The number of shares transacted."),
        AllocAttribute(CodingKeys.sharePrice, .double, isRequired: false, isKey: false, "The price at which the share(s) transacted."),
        AllocAttribute(CodingKeys.realizedGainShort, .double, isRequired: false, isKey: false, "The total short-term realized gain (or loss) from a sale."),
        AllocAttribute(CodingKeys.realizedGainLong, .double, isRequired: false, isKey: false, "The total long-term realized gain (or loss) from a sale."),
    ]
}
