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

extension MAccount: AllocAttributable {
    public static var attributes: [AllocAttribute] = [
        AllocAttribute(CodingKeys.accountID,
                       .string,
                       isRequired: true,
                       isKey: true,
                       "The account number of the account."),
        AllocAttribute(CodingKeys.title,
                       .string,
                       isRequired: false,
                       isKey: false,
                       "The title of the account."),
        AllocAttribute(CodingKeys.isActive,
                       .bool,
                       isRequired: false,
                       isKey: false,
                       "Is the account active?"),
        AllocAttribute(CodingKeys.isTaxable,
                       .bool,
                       isRequired: false,
                       isKey: false,
                       "Is the account taxable?"),
        AllocAttribute(CodingKeys.canTrade,
                       .bool,
                       isRequired: false,
                       isKey: false,
                       "Can you trade securities in the account?"),
        AllocAttribute(CodingKeys.strategyID,
                       .string,
                       isRequired: false,
                       isKey: false,
                       "The strategy associated with this account, if any."),
    ]
}
