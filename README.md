# AllocData

<img align="right" src="https://github.com/openalloc/AllocData/blob/main/Images/logo.png" width="100" height="100"/>An open data model for financial applications, typically those used by the do-it-yourself investor.

## Entities

Presently nine(9) entities are defined in the _AllocData_ data model, each with their own schema.

### MAccount

This is the ‘openalloc/account’ schema.

Each row of the Accounts table describes a unique account.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| accountID | string | true | true | The account number of the account. |
| title | string | false | false | The title of the account. |
| isActive | bool | false | false | Is the account active? |
| isTaxable | bool | false | false | Is the account taxable? |
| canTrade | bool | false | false | Can you trade securities in the account? |

### MAllocation

This is the ‘openalloc/allocation’ schema.

Each row of the Allocations table describes a ‘slice’ of a strategy’s
allocation pie.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| allocationStrategyID | string | true | true | The strategy associated with this allocation. |
| allocationAssetID | string | true | true | The asset of the allocation. |
| targetPct | double | false | false | The fraction of the asset in the strategy. |
| isLocked | bool | false | false | Whether the targetPct is locked (or floating). |

### MAsset

This is the ‘openalloc/asset’ schema.

Each row of the Assets table describes a unique asset class.

It also establishes relations between assets.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| assetID | string | true | true | The id of the asset. |
| title | string | false | false | The title of the asset. |
| colorCode | int | false | false | The code for the asset's color palette. |
| parentAssetID | string | false | false | The id of the parent of the asset. |

### MCap

This is the ‘openalloc/cap’ schema.

This table describes limits on allocation for an asset class within an
account.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| capAccountID | string | true | true | The account in which the limit will be imposed. |
| capAssetID | string | true | true | The asset in which the limit will be imposed. |
| limitPct | double | false | false | Allocate no more than this fraction of the account's capacity to the asset. |

### MHistory

This is the ‘openalloc/history’ schema.

A table of recent transaction history, including purchases and sales.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| transactionID | string | false | true | Unique transaction identifier for the history record. |
| historyAccountID | string | true | false | The account in which the transaction occurred. |
| historySecurityID | string | true | false | The security involved in the transaction. |
| shareCount | double | false | false | The number of shares transacted. |
| sharePrice | double | false | false | The price at which the share(s) transacted. |
| realizedGainShort | double | false | false | The total short-term realized gain (or loss) from a sale. |
| realizedGainLong | double | false | false | The total long-term realized gain (or loss) from a sale. |
| transactedAt | date | false | false | The date of the transaction. |

### MHolding

This is the ‘openalloc/holding’ schema.

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

This is the ‘openalloc/security’ schema.

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

This is the ‘openalloc/strategy’ schema.

Each row of the Strategies table describes a single allocation strategy.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| strategyID | string | true | true | The name of the strategy. |
| title | string | false | false | The title of the strategy. |

### MTracker

This is the ‘openalloc/tracker’ schema.

Each row of the Tracker table describes a many-to-many
relationship between Securities.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| trackerID | string | true | true | The name of the tracking index. |
| title | string | false | false | The title of the tracking index. |

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
