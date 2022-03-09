# AllocData

<img align="right" src="https://github.com/openalloc/AllocData/blob/main/Images/logo.png" width="100" height="100"/>An open data model for financial applications, typically those used by the do-it-yourself investor.

Available as an open source Swift library to be incorporated in other apps.

_AllocData_ is part of the [OpenAlloc](https://github.com/openalloc) family of open source Swift software tools.

## Entities

The following entities are defined in the _AllocData_ data model.

### MAccount

This is the `openalloc/account` schema.

Each row of the Accounts table describes a unique account.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| accountID | string | true | true | The account number of the account. |
| title | string | false | false | The title of the account. |
| isTaxable | bool | false | false | Is the account taxable? (default: false) |
| canTrade | bool | false | false | Can you trade securities in the account? (default: false) |
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
| assetID | string | true | true | The identifier of the asset. (e.g., 'Bond') |
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

### MHolding

This is the `openalloc/holding` schema.

A table where each row describes an individual position, with account,
ticker, share count, share basis, etc.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| holdingAccountID | string | true | true | The account hosting the position. |
| holdingSecurityID | string | true | true | The security of the position. |
| holdingLotID | string | true | true | The lot of the position, if any. |
| shareCount | double | false | true | The number of shares held in the position. |
| shareBasis | double | false | true | The price paid per share of the security. |
| acquiredAt | date | false | true | The date of the acquisition. |

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
| strategyID | string | true | true | The identifier of the strategy. |
| title | string | false | false | The title of the strategy. |

### MTracker

This is the `openalloc/tracker` schema.

Each row of the Tracker table describes a many-to-many
relationship between Securities.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| trackerID | string | true | true | The identifier of the tracking index. |
| title | string | false | false | The title of the tracking index. |

### MTransaction

This is the `openalloc/transaction` schema.

A table of recent transaction history, including purchases, sales, and other actions.

NOTE: this replaces the deprecated 'MHistory' entity.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| txnAction | string | true | true | The code of the type of transaction (see below). |
| txnTransactedAt | date | true | true | The date of the transaction. |
| txnAccountID | string | true | true | The account in which the transaction occurred. |
| txnSecurityID | string | true | true | The security involved in the transaction. |
| txnLotID | string | true | true | The lot of the position involved in the transaction (blank if none). |
| txnShareCount | double | true | true | The number of shares transacted. |
| txnSharePrice | double | false | false | The price at which the share(s) transacted. (0 if none provided). |
| realizedGainShort | double | false | false | The total short-term realized gain (or loss) from a sale. |
| realizedGainLong | double | false | false | The total long-term realized gain (or loss) from a sale. |

Note that brokerage exports may omit share price on security transfers.

The action types:

| Type | ShareCount | SharePrice | SecurityID | Descript |
| ---- | ---------- | ---------- | ---------- | -------- |
| buysell | \<0 if sale; \>0 if purchase | \>0, price/share | required | Purchase/sale of security to/from cash. | 
| income | amount of income | 1.0 (cash) | if dividend | Income from interest, or the dividend of a stock/ETF/etc.. | 
| transfer | \<0 is outgoing; \>0 is incoming | 1.0 if cash; \>0 for security; nil if none provided | if not cash | Transfer of security/cash to/from external source. | 
| miscflow | \<0 is outgoing; \>0 is incoming | 1.0 (cash) | ignored | Neutral (non-income) cashflow to/from account. | 

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

Each row of the valuation position table describes a position captured at a particular time for a valuation snapshot. It can represent multiple holdings of an account for an asset class.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| valuationPositionSnapshotID | string | true | true | The valuation snapshot ID for the position. |
| valuationPositionAccountID | string | true | true | The account hosting the position. |
| valuationPositionAssetID | string | true | true | The asset class of the position. |
| totalBasis | double | true | false | The price paid to establish position. |
| marketValue | double | true | false | The market value of the position. |

### MValuationCashflow

This is the `openalloc/valuation/cashflow` schema.

Each row of the valuation cashflow table describes a cash flow at a particular time. It is not explicitly bound to any valuation snapshot. Typically, multiple history items are rolled up into a cash flow item.

| Name | Type | IsRequired | IsKey | Descript |
| ---- | ---- | ---------- | ----- | -------- |
| valuationCashflowTransactedAt | date | true | true | The timestamp when this flow occurred. |
| valuationCashflowAccountID | string | true | true | The account in which the flow occurred. |
| valuationCashflowAssetID | string | true | true | The asset class flowed. |
| amount | double | true | false | The amount of the flow (-outgoing, +incoming). |

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

Entities in the data model all conform to the following protocols:

### Base

Base functionality for all entities. Currently just a schema identifier.

```swift
public protocol AllocBase {
    static var schema: AllocSchema { get }
}
```

### Keyed

Used to retrieve and generate the entity's primary key.

This new struct-based implementation replaces the old string-based one.

The `emptyKey` property can be used for picker tag values, as an example.

```swift
public protocol AllocKeyed: Hashable {
    associatedtype Key: Hashable, Codable

    var primaryKey: Key { get }
    static var emptyKey: Key { get }
}
```

The entities also conform to the `Identifiable` protocol where the id is the primary key.

### Rowed

Used to parse (decode) and generate (encode) delimited data for the entities.

```swift
public protocol AllocRowed: AllocKeyed {
    // pre-decoded row, without strong typing
    typealias RawRow = [String: String]

    // decoded row, with stronger typing
    typealias DecodedRow = [String: AnyHashable]

    // create object from row
    init(from row: DecodedRow) throws

    static func decode(_ rawRows: [RawRow], rejectedRows: inout [RawRow]) throws -> [DecodedRow]

    // additive update from row
    mutating func update(from row: DecodedRow) throws

    static func getPrimaryKey(_ row: DecodedRow) throws -> Key
}
```

### Attributable

Used to fetch a description of the entity's attributes.

```swift
public protocol AllocAttributable {
    static var attributes: [AllocAttribute] { get }
}
```

## See Also

Swift open-source libraries (by the same author):

* [FINporter](https://github.com/openalloc/FINporter) - library and command-line tool to transform various specialized finance-related formats to the standardized schema of AllocData
* [SwiftTabler](https://github.com/openalloc/SwiftTabler) - multi-platform SwiftUI component for displaying (and interacting with) tabular data
* [SwiftDetailer](https://github.com/openalloc/SwiftDetailer) - multi-platform SwiftUI component for editing fielded data
* [SwiftCompactor](https://github.com/openalloc/SwiftCompactor) - formatters for the concise display of Numbers, Currency, and Time Intervals
* [SwiftModifiedDietz](https://github.com/openalloc/SwiftModifiedDietz) - A tool for calculating portfolio performance using the Modified Dietz method
* [SwiftNiceScale](https://github.com/openalloc/SwiftNiceScale) - generate 'nice' numbers for label ticks over a range, such as for y-axis on a chart
* [SwiftRegressor](https://github.com/openalloc/SwiftRegressor) - a linear regression tool that’s flexible and easy to use
* [SwiftSeriesResampler](https://github.com/openalloc/SwiftSeriesResampler) - transform a series of coordinate values into a new series with uniform intervals
* [SwiftSimpleTree](https://github.com/openalloc/SwiftSimpleTree) - a nested data structure that’s flexible and easy to use

And commercial apps using this library (by the same author):

* [FlowAllocator](https://flowallocator.app/FlowAllocator/index.html) - portfolio rebalancing tool for macOS
* [FlowWorth](https://flowallocator.app/FlowWorth/index.html) - a new portfolio performance and valuation tracking tool for macOS


## License

Copyright 2021 FlowAllocator LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Contributing

Contributions are welcome. You are encouraged to submit pull requests to fix bugs, improve documentation, or offer new features. 

The pull request need not be a production-ready feature or fix. It can be a draft of proposed changes, or simply a test to show that expected behavior is buggy. Discussion on the pull request can proceed from there.

Contributions should ultimately have adequate test coverage. See tests for current entities to see what coverage is expected.
