//
//  MValuationCashflow.swift
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

public struct MValuationCashflow: Hashable & AllocBase {
    public var transactedAt: Date // key
    public var accountID: String // key
    public var assetID: String // key

    public var amount: Double
    public var reconciled: Bool

    public static var schema: AllocSchema { .allocValuationCashflow }

    public init(
        transactedAt: Date,
        accountID: String,
        assetID: String,
        amount: Double = 0,
        reconciled: Bool = false
    ) {
        self.transactedAt = transactedAt
        self.accountID = accountID
        self.assetID = assetID
        self.amount = amount
        self.reconciled = reconciled
    }
}

extension MValuationCashflow: Codable {
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case transactedAt = "valuationCashflowTransactedAt"
        case accountID = "valuationCashflowAccountID"
        case assetID = "valuationCashflowAssetID"
        case amount
        case reconciled
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        transactedAt = try c.decode(Date.self, forKey: .transactedAt)
        accountID = try c.decode(String.self, forKey: .accountID)
        assetID = try c.decode(String.self, forKey: .assetID)
        amount = try c.decode(Double.self, forKey: .amount)
        reconciled = try c.decode(Bool.self, forKey: .reconciled)
    }
}

extension MValuationCashflow: CustomStringConvertible {
    public var description: String {
        let formattedDate = MValuationSnapshot.unparseDate(transactedAt)
        return "transactedAt=\(formattedDate) accountID=\(accountID) assetID=\(assetID) amount=\(amount) reconciled=\(reconciled)"
    }
}
