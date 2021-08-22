# AllocData

<img align="right" src="https://github.com/openalloc/AllocData/blob/main/Images/logo.png" width="100" height="100"/>An open data model for financial applications, typically those used by the do-it-yourself investor.

## Entities

The following entities are defined in the _AllocData_ data model.

### MAccount

This is the `openalloc/account` schema.

Each row of the Accounts table describes a unique account.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| accountID | string | true | true | The account number of the account. |
| title | string | false | false | The title of the account. |
| isActive | bool | false | false | Is the account active? (NOTE: no longer used by FlowAllocator) |
| isTaxable | bool | false | false | Is the account taxable? |
| canTrade | bool | false | false | Can you trade securities in the account? |
| accountStrategyID | string | false | false | The strategy associated with this account, if any. |

### MAllocation

This is the `openalloc/allocation` schema.

Each row of the Allocations table describes a ‘slice’ of a strategy’s
allocation pie.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| allocationStrategyID | string | true | true | The strategy associated with this allocation. |
| allocationAssetID | string | true | true | The asset of the allocation. |
| targetPct | double | false | false | The fraction of the asset in the strategy. |
| isLocked | bool | false | false | Whether the targetPct is locked (or floating). |

### MAsset

This is the `openalloc/asset` schema.

Each row of the Assets table describes a unique asset class.

It also establishes relations between assets.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| assetID | string | true | true | The id of the asset. |
| title | string | false | false | The title of the asset. |
| colorCode | int | false | false | The code for the asset's color palette. |
| parentAssetID | string | false | false | The id of the parent of the asset. |

### MCap

This is the `openalloc/cap` schema.

This table describes limits on allocation for an asset class within an
account.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| capAccountID | string | true | true | The account in which the limit will be imposed. |
| capAssetID | string | true | true | The asset in which the limit will be imposed. |
| limitPct | double | false | false | Allocate no more than this fraction of the account's capacity to the asset. |

### MHistory

This is the `openalloc/history` schema.

A table of recent transaction history, including purchases and sales.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| transactionID | string | false | true | Unique transaction identifier for the history record. |
| historyAccountID | string | true | false | The account in which the transaction occurred. |
| historySecurityID | string | true | false | The security involved in the transaction. |
| historyLotID | string | false | false | The lot of the position involved in the transaction, if any. |
| shareCount | double | false | false | The number of shares transacted. |
| sharePrice | double | false | false | The price at which the share(s) transacted. |
| realizedGainShort | double | false | false | The total short-term realized gain (or loss) from a sale. |
| realizedGainLong | double | false | false | The total long-term realized gain (or loss) from a sale. |
| transactedAt | date | false | false | The date of the transaction. |

### MHolding

This is the `openalloc/holding` schema.

A table where each row describes an individual position, with account,
ticker, share count, share basis, etc.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| holdingAccountID | string | true | true | The account hosting the position. |
| holdingSecurityID | string | true | true | The security of the position. |
| holdingLotID | string | true | true | The lot of the position, if any. |
| shareCount | double | false | false | The number of shares held in the position. |
| shareBasis | double | false | false | The price paid per share of the security. |
| acquiredAt | date | false | false | The date of the acquisition. |

### MSecurity

This is the `openalloc/security` schema.

Table where each row describes a unique security, with its ticker, asset
class and latest price.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| securityID | string | true | true | The symbol/securityID of the security. |
| securityAssetID | string | false | false | The asset class of the security. |
| sharePrice | double | false | false | The reported price of one share of the security. |
| updatedAt | date | false | false | The timestamp of the the reported price. |
| securityTrackerID | string | false | false | The index the security is tracking. |

### MStrategy

This is the `openalloc/strategy` schema.

Each row of the Strategies table describes a single allocation strategy.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| strategyID | string | true | true | The name of the strategy. |
| title | string | false | false | The title of the strategy. |

### MTracker

This is the `openalloc/tracker` schema.

Each row of the Tracker table describes a many-to-many
relationship between Securities.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| trackerID | string | true | true | The name of the tracking index. |
| title | string | false | false | The title of the tracking index. |

### MRebalanceAllocation

This is the `openalloc/rebalance/allocation` schema.

Each row of the RebalanceAllocation table describes an allocation that drives a rebalance.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| allocationAccountID | string | true | true | The account to which the asset is allocated. |
| allocationAssetID | string | true | true | The asset class of the allocation. |
| amount | double | true | false | The amount in dollars allocated. |

### MRebalancePurchase

This is the `openalloc/rebalance/purchase` schema.

Each row of the RebalancePurchase table describes an acquisition of a position to satisfy a rebalance.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| purchaseAccountID | string | true | true | The account to host the position. |
| purchaseAssetID | string | true | true | The asset class of the position to acquire. |
| amount | double | true | false | The amount in dollars to acquire. |

### MRebalanceSale

This is the `openalloc/rebalance/sale` schema.

Each row of the RebalanceSale table describes a liquidation of a position to satisfy a rebalance.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| saleAccountID | string | true | true | The account hosting the position. |
| saleSecurityID | string | true | true | The security of the position. |
| saleLotID | string | true | true | The lot of the position, if any. |
| amount | double | true | false | The amount in dollars to liquidate from this position. |
| shareCount | double | false | false | Estimated number of shares to liquidate from this position. |
| liquidateAll | bool | false | false | If true, the entire position can be liquidated. |

### MValuationSnapshot

This is the `openalloc/valuation/snapshot` schema.

Each row of the ValuationSnapshot table describes a valuation captured at a particular time.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| valuationSnapshotID | string | true | true | The unique valuation snapshot identifier. |
| capturedAt | date | true | false | The timestamp when the snapshot was created. |

### MValuationPosition

This is the `openalloc/valuation/position` schema.

Each row of the ValuationPosition table describes a position/holding captured at a particular time.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| valuationPositionSnapshotID | string | true | true | The valuation snapshot ID for the position. |
| valuationPositionAccountID | string | true | true | The account hosting the position. |
| valuationPositionSecurityID | string | true | true | The security/ticker of the position. |
| valuationPositionLotID | string | true | true | The lot of the position, if any. |
| shareCount | double | true | false | The price paid per share of the security to establish position. |
| shareBasis | double | true | false | The number of shares remaining in the position. |
| sharePrice | double | true | false | The price per share at the snapshot. |
| assetID | string | true | false | The asset class of the security. |

### MValuationTransaction

This is the `openalloc/valuation/transaction` schema.

Each row of the ValuationTransaction table describes a transaction at a particular time. It is not explicitly bound to any ValuationSnapshot.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| valuationTransactionTransactedAt | date | true | true | The timestamp when this transaction occurred. |
| valuationTransactionAccountID | string | true | true | The account transacted. |
| valuationTransactionSecurityID | string | true | true | The security/ticker transacted. |
| valuationTransactionLotID | string | true | true | The lot of the transacted, if any. |
| shareCount | double | true | false | The number of shares transacted (-Sale, +Purchase). |
| sharePrice | double | true | false | The price per share transacted. |
| isGenerated | bool | true | false | If true, this record was created to reconcile share counts. |

### MSourceMeta

This is the `openalloc/meta/source` schema.

Each row of the SourceMeta table describes an import or transformation of source data. It can also include extracted data, such as the published export date found within.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| sourceMetaID | string | true | true | The unique ID of the source meta record. |
| url | string | false | false | The source URL, if any. |
| importerID | string | false | false | The id of the importer/transformer, if any. |
| exportedAt | date | false | false | The published export date of the source data, if any. |

## Data Formats

### Dates

In delimited text files, the dates should be in the ISO 8601 / RFC 3339 format (e.g., "2012-12-31T19:00:00Z").

## API

Entities in the data model all conform to AllocBase protocol.

```swift
public protocol AllocBase: Codable {
    // pre-decoded row, without strong typing
    typealias RawRow = [String: String]

    // decoded row, with strong typing
    typealias Row = [String: AnyHashable?]

    static var schema: AllocSchema { get }
    static var attributes: [AllocAttribute] { get }

    // Note that key values should NOT be persisted. Their
    // format and composition may vary across platforms and
    // versions.
    var primaryKey: AllocKey { get }

    // create object from row
    init(from row: Row) throws

    // additive update from row
    mutating func update(from row: Row) throws

    static func getPrimaryKey(_ row: Row) throws -> AllocKey

    static func decode(_ rawRows: [RawRow], rejectedRows: inout [Row]) throws -> [Row]
}
```

## Applications using AllocData

* [FINporter](https://github.com/openalloc/FINporter)  - a library and command-line tool to transform various specialized formats to the standardized schema of AllocData

* [FlowAllocator](https://flowallocator.app) - a new portfolio rebalancing tool for macOS

## License

Copyright 2021 FlowAllocator LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Contributing

Contributions are welcome. You are encouraged to submit pull requests to fix bugs, improve documentation, or offer new features. 

The pull request need not be a production-ready feature or fix. It can be a draft of proposed changes, or simply a test to show that expected behavior is buggy. Discussion on the pull request can proceed from there.

Contributions should ultimately have adequate test coverage. See tests for current entities to see what coverage is expected.
