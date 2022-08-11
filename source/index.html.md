---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  

toc_footers:
  - <a href='https://bitronit.com/tr/'>Bitronit Exchange</a>

search: true

code_clipboard: false

meta:
  - name: description
    content: Documentation for the Bitronit API
---

# Introduction

## Get Your API Key and Secret Key

- Create your API Key and Secret Key from [Bitronit API Management](https://bitronit.com/en/publicApi) page in Bitronit dashboard.
- You can manage scope restrictions for your API Key afterwards.
- You can bind an IP for your API Key to increase your account security.

## API Key Setup

- Endpoints will require an API Key.
- Once API key is created, it is recommended to set IP restrictions on the key for security reasons.
- <b> Never share your API key/secret key to ANYONE. </b>

<aside class="warning">
  If the API keys were accidentally shared, please delete them immediately and create a new key.
</aside>

## API Key Restrictions

- To enable withdrawals and trading via the API, the API key restriction needs to be modified through the Bitronit UI.

# General Info

## General API Information

<aside class="warning">
  This document is for v2 version of our API. To view the older v1 version, <a href="https://docs.bitronit.com">see here</a>.
</aside>

- The base endpoint is: <b> https://bitronit.com/api/v2 </b>
- All endpoints successful requests returns either a JSON object or array.
- There are `PUBLIC` and `SIGNED` endpoints. 
- `PUBLIC` endpoints don't require Authentication and Signature Headers. 
- `SIGNED` endpoints require Authentication and Signature Headers.

> Error response:

```json
{
  "error": "Not Found",
  "message": "IBAN_NOT_FOUND",
  "path": "/users/withdrawals/fiat",
  "requestId": "7ecc8c03-36054",
  "status": 404,
  "timestamp": "2021-12-15T15:35:20.603+03:00"
}
```

### Error Codes and Messages

- If there is an error, the API will return an error with a message of the reason.

### General Information on Endpoints

- For `GET` endpoints, parameters must be sent as a query string.
- For `POST`, `PUT`, and `DELETE` endpoints, the parameters may be sent as a query string or in the request body.
- Parameters may be sent in any order.

## Limits

### IP Limits

- Users can have at most 30 API-keys.
- An API-key can have at most 4 IP restrictions.
- IP's should be in public range. Private ranges are not allowed.
- <b> The limits on the API are based on the IPs, not the API keys. </b>

### Rate Limits

- Hitting our rate limits will result in HTTP 429 errors.

## Authentication

- For `SIGNED` requests, the following headers must be sent with the request:

  - `Authorization`: Your API key as bearer token
  - `Signature`: SHA256 HMAC of the query string concatenated with the request body, using your `API secret`, as a `Base64` string

- All endpoints are `SIGNED` endpoints.
- The signature is not case-sensitive.
- API-keys and secret-keys <b> are case-sensitive. </b>

### Signed Endpoint Examples

Here are step-by-step examples of how to send a valid signed payload from the Linux command line using `echo`, `openssl`, and `curl`.

Query parametered requests' signatures should be calculated in parameters order.

Key       | Value
--------- | -----------
apiKey    | 966304e1-9be0-4d79-a1b0-95d069a7bfaf
secretKey | c0bad7a7eb95876bcd646bcf7f42e39ff1dd75311edb4f4df84de3e41f3b3c5d


> **HMAC SHA256 signature:**

```shell
$ echo -n "asset=ETH&type=Withdraw" | openssl dgst -sha256 -hmac "c0bad7a7eb95876bcd646bcf7f42e39ff1dd75311edb4f4df84de3e41f3b3c5d" -binary | base64
    (stdin)= 4+NG7pPYMfs51VmIlZZNPe69Bamo/PsG6aMix0q6iSs=
```
> **curl command:**

```shell
(HMAC SHA256)
$ curl -H "Authorization: Bearer 966304e1-9be0-4d79-a1b0-95d069a7bfaf" -H "Signature: yDyq8EkvBoOm+GKKxch4TwD6K0L0q5KaTNLVQv8F0rg=" -X GET 'https://bitronit.com/api//users/restrictions?asset=ETH&type=Withdraw'

```

**GET /users/restrictions**

Parameter     | Value
---------     | -----
asset	   | ETH
type  | Withdraw


- queryString:

asset=ETH&type=Withdraw


**POST /users/orders/cancel**

> **HMAC SHA256 signature:**

```shell
$ echo -n '{"priceBelow": 12.5, "priceAbove": 7.8, "operationDirection": "Buy", "baseAsset": "ETH", "quoteAsset": "TRY"}' | openssl dgst -sha256 -hmac "c0bad7a7eb95876bcd646bcf7f42e39ff1dd75311edb4f4df84de3e41f3b3c5d" -binary | base64
    (stdin)= zEakMgO8mSn+L3DIN9mEMOdoBvHuzucjdDuTvpL1xCQ=
```
> **curl command:**

```shell
(HMAC SHA256)
$ curl -H "Authorization: Bearer 966304e1-9be0-4d79-a1b0-95d069a7bfaf" -H "Signature: xfxO7ec5WyzUleFLNjqFyUmsKOvLnTxYCvYXb7SNkfQ=" -X POST 'https://bitronit.com/api/users/orders/cancel' -d '{"priceBelow":12.5,"priceAbove":7.8,"operationDirection":"Buy","baseAsset":"ETH","quoteAsset":"TRY"}'

```


Parameter           | Value
---------           | -----
priceBelow          | 12.5
priceAbove          | 7.8
operationDirection  | Buy
baseAsset           | "ETH"
quoteAsset          | "TRY"

- requestBody:

{"priceBelow": 12.5, "priceAbove": 7.8, "operationDirection": "Buy", "baseAsset": "ETH", 
"quoteAsset": "TRY"}


# Public HTTP API

## Get assets

> Request:

```http
GET /assets
```
> Response:

```json
[
  {
    "id": 2,
    "ticker": "ETH",
    "fullName": "Ethereum",
    "circulatingSupply": 121822787.43650000,
    "circulatingSupplyUpdateDate": "2022-08-04T09:00:05.881614Z",
    "fiat": false
  }
]
```

Returns all assets.

### Response Format

Field        | Type      | Description
------------ | --------- | -----------
id        | Long | Unique ID of the asset
ticker | String | Symbol of the asset
fullName | String |
circulatingSupply | BigDecimal |
circulatingSupplyUpdateDate | String | ISO8601 Date
fiat | Boolean | True if asset is a fiat like TRY

## Get a specific asset 

> Request:

```http
GET /assets/{asset}
```

> Response:

```json
{
  "id": 2,
  "ticker": "ETH",
  "fullName": "Ethereum",
  "circulatingSupply": 121822787.43650000,
  "circulatingSupplyUpdateDate": "2022-08-04T09:00:05.881614Z",
  "fiat": false
}
```

Returns the assets detail.

### URL Parameters

Parameter | Description
--------- | -----------
asset    | Symbol(ticker) of the asset


### Response Format

For the response format please refer to [Get trading pairs](/#get-trading-pairs)


## Get network configuration

> Request:

```http
GET /crypto-network
```

> Response:

```json
[
  {
    "id": 17,
    "network": "ETH",
    "asset": "USDT",
    "minConfirmations": 1,
    "depositEnabled": true,
    "withdrawEnabled": true,
    "withdrawFee": 0.00040000,
    "name": "Ethereum (ERC20)"
  },
]
```

Returns the crypto network detail(s).

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
asset | no | String | Symbol(ticker) of the asset

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
id               | Long | Unique ID of the network config
network          | String | Symbol of the Network
asset            | String | Asset(ticker) of the network config
minConfirmations | Int | Minimum confirmations required after the deposit
depositEnabled   | Boolean | True if deposits enabled for the network
withdrawEnabled  | Boolean | True if withdrawals enabled for the network
withdrawFee      | BigDecimal | Withdraw fee of the network
name             | String | Long name of the network

## Get crypto withdraw config

> Request:

```http
GET /assets/{asset}/network/{network}/crypto-withdraw-config
```

> Response:

```json
{
  "withdrawEnabled": true,
  "withdrawFee": 0.00020000
}
```

Returns the crypto withdraw config for the asset with given network.

### URL Parameters

Parameter | Description
--------- | -----------
asset    | Symbol(ticker) of the asset
network    | Crypto Network

Available networks can be retrieved from [Get assets](/#get-assets)

### Response Format

Field        | Type      | Description
------------ | --------- | -----------
withdrawEnabled  | Boolean | True if withdrawals enabled
withdrawFee | BigDecimal | Current withdraw fee

## Get fiat withdraw config

> Request:

```http
GET /assets/{asset}/fiat-withdraw-config
```

> Response:

```json
{
  "withdrawEnabled": true,
  "withdrawFee": 5.00000000
}
```

Returns the fiat withdraw config for the asset.

### URL Parameters

Parameter | Description
--------- | -----------
asset    | Symbol(ticker) of the asset


### Response Format

For the response format please refer to [Get crypto withdraw config](/#get-crypto-withdraw-config)

## Get candlesticks

> Request:

```http
Limit, period calculation:
  For 1 week candlestick data,
  period = 240(4 hours),
  limit = 42
  42*4 = 168(1 week)
  
GET /candlesticks?baseAsset={baseAsset}&quoteAsset={quoteAsset}&period={period}&startTime={startTime}&endTime={endTime}&limit={limit}
```

> Response:

```shell
[
  [opentime, open, high, low, close, volume],
  [Timestamp, BigDecimal, BigDecimal, BigDecimal, BigDecimal, BigDecimal],
  [1659529500000, 1671.780000000000000, 1671.780000000000000, 1671.780000000000000, 1671.780000000000000, 10.114269000000000],
  ...
]
```

Filter or limit the candlesticks with query parameters.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAsset | yes | String     | Symbol(ticker) of the base asset
quoteAsset | yes | String    | Symbol(ticker) of the quote asset
period    | yes | Int        | Period of the candlestick in minutes.
startTime    | no | Timestamp   | Epoch milliseconds
endTime    | no | Timestamp     | Epoch milliseconds
limit    | no | Int        | Maximum data number for candlestick. [1-500] Default: 500


## Get market info

> Request:

```http
GET /markets
```

> Response:

```json
[
  {
    "currentPrice": 29332.00,
    "dailyVolume": 17287.229462800000000,
    "dailyChange": -1.39,
    "baseAsset": "ETH",
    "quoteAsset": "TRY",
    "highestPrice": 30237.000000000000000,
    "lowestPrice": 29032.000000000000000,
    "dailyNominalChange": -414.000000000000000
  }
]
```

Returns market info for all pairs.

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
currentPrice     | BigDecimal | Current market price of the pair
dailyVolume      | BigDecimal | Daily volume of the pair
dailyChange      | BigDecimal | Daily percentage of change in the price
baseAsset        | String | Symbol(ticker) of the base asset
quoteAsset       | String | Symbol(ticker) of the quote asset
highestPrice     | BigDecimal | Daily highest price of the pair
lowestPrice      | BigDecimal | Daily lowest price of the pair daily
dailyNominalChange | BigDecimal | Daily nominal change in the pair

## Get orderbook data

> Request

```http
GET /orders/group?baseAsset={baseAsset}&quoteAsset={quoteAsset}&scale={scale}
```

> Response: 

```json
{
  "timestamp": "2022-08-04T10:50:30.829108Z",
  "version": 0,
  "sell": {
    "1621.15": 0.003210000000000,
    "1621.28": 0.003300000000000,
    "1621.43": 0.003170000000000,
    "1621.68": 0.006500000000000
  },
  "buy": {
    "1610.43": 0.004220000000000,
    "1610.40": 0.008120000000000,
    "1610.39": 0.004840000000000,
    "1610.33": 0.007150000000000
  }
}
```

Get orderbook data for the given trading pair and scale

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAsset | yes | String | Symbol(ticker) of the base asset
quoteAsset | yes | String | Symbol(ticker) of the quote asset
scale | yes | int

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
timestamp     | BigDecimal | ISO8601 Time of the fetched data
version      | BigDecimal | 
sell      | Map<BigDecimal, BigDecimal> | Sell orders key as price and the value as its amount 
buy        | Map<BigDecimal, BigDecimal> | Buy orders key as price and the value as its amount 

## Get transactions

> Request:

```http
GET /transactions?baseAsset={baseAsset}&quoteAsset={quoteAsset}&page={page}&size={size}
```

> Response:

```json
[
  {
    "baseAsset": "ETH",
    "quoteAsset": "TRY",
    "transactionDate": "2021-08-31T11:56:31.245652Z",
    "matchedQuantity": 0.00390000,
    "matchedPrice": 28408.20300000,
    "buyerTaker": true
  }
]

```

Filter transactions with query parameters.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAsset | no | String | Symbol(ticker) of the base asset
quoteAsset | no | String | Symbol(ticker) of the quote asset
page | no | Int            | Page number
size    | no | Int         | Number of items per page

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
baseAsset     | String | Symbol(ticker) of the base asset
quoteAsset      | String | Symbol(ticker) of the quote asset
transactionDate  | String | ISO8601 Date of the transaction
matchedQuantity     | BigDecimal | Matched quantity of transaction
matchedPrice       | BigDecimal | Matched price of the transaction
buyerTaker     | Boolean | True if the buy order is a taker


## Get trading pairs

> Request:

```http
GET /trading-pairs
```

> Response:

```json
[
  {
    "baseAsset": "ETH",
    "quoteAsset": "USDT",
    "symbol": "ETHUSDT",
    "status": "Trading",
    "maxNumOrders": 100000,
    "minPrice": 0.01,
    "maxPrice": 1000000.1324123412,
    "tickScale": 2,
    "productScale": 2,
    "multiplierUp": 5,
    "multiplierDown": 0.2,
    "averagePriceCount": 1,
    "minQuantity": 0.00001,
    "maxQuantity": 0.5,
    "stepScale": 5,
    "minNotional": 10,
    "marketMinQuantity": 0.00001,
    "marketMaxQuantity": 0.5,
    "makerFeePercentageValue": 0.25,
    "takerFeePercentageValue": 0.35,
    "isMarketEnabled": false,
    "isLimitEnabled": false,
    "isStopEnabled": false,
    "applyToMarket": false,
    "marketStepSize": 0.00001
  }
]
```

Retrieve all trading pair details.

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
baseAsset        | String | Symbol(ticker) of the base asset
quoteAsset       | String | Symbol(ticker) of the quote asset
symbol           | String | Pair symbol
status           | TradingPairStatus | _Trading, Maintenance, ClosedForOrders, Preparing, Suspended, UnderInvestigation, PendingForApproval_
maxNumOrders     | Int | Maximum number of orders for the pair
minPrice         | BigDecimal | Minimum price to place order
maxPrice         | BigDecimal | Maximum price for to place order
tickScale        | String | 
productScale     | String | 
multiplierUp     | BigDecimal | 
multiplierDown   | BigDecimal |
averagePriceCount | Short |
minQuantity      | BigDecimal | Minimum quantity to place order
maxQuantity      | BigDecimal | Max quantity to place order
stepScale        | Short | 
minNotional      | BigDecimal |
marketMinQuantity | BigDecimal |
marketMaxQuantity | BigDecimal |
makerFeePercentageValue | BigDecimal | Maker orders fee percentage
takerFeePercentageValue | BigDecimal | Taker orders fee percentage
isMarketEnabled  | Boolean | True when market orders enabled
isLimitEnabled   | Boolean | True when limit orders enabled
isStopEnabled    | Boolean | True when stop orders enabled
applyToMarket    | Boolean |
marketStepSize   | Boolean |

## Get trading pair detail

> Request:

```http
GET /trading-pairs/base-asset/{baseAsset}/quote-asset/{quoteAsset}
```

> Response:

```json
{
  "baseAsset": "ETH",
  "quoteAsset": "USDT",
  "symbol": "ETHUSDT",
  "status": "Trading",
  "maxNumOrders": 100000,
  "minPrice": 0.01,
  "maxPrice": 1000000.1324123412,
  "tickScale": 2,
  "productScale": 2,
  "multiplierUp": 5,
  "multiplierDown": 0.2,
  "averagePriceCount": 1,
  "minQuantity": 0.00001,
  "maxQuantity": 0.5,
  "stepScale": 5,
  "minNotional": 10,
  "marketMinQuantity": 0.00001,
  "marketMaxQuantity": 0.5,
  "makerFeePercentageValue": 0.25,
  "takerFeePercentageValue": 0.35,
  "isMarketEnabled": false,
  "isLimitEnabled": false,
  "isStopEnabled": false,
  "applyToMarket": false,
  "marketStepSize": 0.00001
}
```

Retrieve trading pair detail by asset

### URL Parameters

Parameter | Description
--------- | -----------
baseAsset    | Symbol(ticker) of the base asset
quoteAsset   | Symbol(ticker) of the quote asset

### Response Format

For the response format please refer to [Get trading pairs](/#get-trading-pairs)

# Private HTTP API

## Get API Key Info

> Request:

```http
GET /users/api-key/info
```
> Response:

```json
[
  {
    "userId": 13863,
    "permissions": [
      "PublicAPI",
      "Withdraw",
      "Trade"
    ]
  }
]
```

Returns user id and permissions info for API Key

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
userId     | Long | Unique user identifier
permissions | List<String> | API Key permission scopes

### Required Scope

`PublicApi`: Basic Scope


## Get crypto deposit history

> Request:

```http
GET /users/deposits/crypto?asset={asset}&page={page}&size={size}
```

> Response:

```json
[
  {
    "id": 0,
    "type": "Deposit",
    "transactionHash": "0xd6c595d3a51bd90f3a9d13737c410bd29129115b0778dfb5d046652ee61940ad",
    "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "address": "0x4a9e4491c60ff88bb4253bd7f1c0d25b51138e97",
    "asset": "ETH",
    "amount": 1000,
    "fee": 0,
    "status": "WaitingForConfirmation",
    "confirmedBlockCount": 5,
    "statusUpdateDate": "2021-12-13T14:01:37.047Z",
    "completeDate": "2021-12-13T14:01:37.047Z",
    "typicalPrice": 0,
    "network": "ETH"
  }
]

```

Filter users crypto deposit history with query parameters.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
asset | no | String | Symbol(ticker) of the asset
page | no | Int            | Page number
size    | no | Int         | Number of items per page

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
id     | Long | Unique Id of the external transaction
type      | **ExternalTransactionType** | _Withdraw, Deposit_
transactionHash  | String | Crypto network transaction hash
transactionUUID  | UUID | Transaction UUID of the external transaction
address     | Int | Crypto wallet address
asset       | String | Symbol(ticker) of the asset
amount     | BigDecimal | Amount of the asset
fee     | String | Fee of the external transaction
status      | **ExternalTransactionStatus** | _Waiting, Pending, Cancelled, Success, WaitingForConfirmation, Verified, Failed_
confirmedBlockCount  | Int | Confirmed block count of the crypto network transaction
statusUpdateDate       | String | ISO8601 Date of the last status update
completeDate     | String | ISO8601 Transaction completion date
network      | String | _BTC, LTC, ETH, BCH, TRON, AVAX, SOL, BNB, BSC, POLYGON_

### Required Scope

`PublicApi`: Basic Scope

## Get fiat deposit history

> Request:

```http
GET /users/deposits/fiat?asset={asset}&page={page}&size={size}
```

> Response:

```json
[
  {
    "id": 0,
    "type": "Deposit",
    "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "asset": "TRY",
    "amount": 1000,
    "fee": 0,
    "status": "WaitingForConfirmation",
    "statusUpdateDate": "2021-12-13T14:01:37.047Z",
    "completeDate": "2021-12-13T14:01:37.047Z",
    "typicalPrice": 0,
    "senderIban": "TR050202000000000001091100",
    "senderBankName": "Test Bankası",
    "receiverIban": "TR400006201493719805071327",
    "receiverBankName": "Test Bankası"
  }
]

```

Filter users fiat deposit history with query parameters.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
asset | no | String | Symbol(ticker) of the asset
page | no | Int            | Page number
size    | no | Int         | Number of items per page


### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
id     | Long | Unique Id of the external transaction
type      | **ExternalTransactionType** | _Withdraw, Deposit_
transactionUUID  | UUID | Transaction UUID of the external transaction
asset       | String |  Symbol(ticker) of the asset
amount     | BigDecimal | Amount of the asset
fee     | String | Fee of the external transaction
status      | **ExternalTransactionStatus** | _Waiting, Pending, Cancelled, Success, WaitingForConfirmation, Verified, Failed_
statusUpdateDate       | String | ISO8601 Date of the last status update
completeDate     | String | ISO8601 Transaction complete date
senderIban      | String | Sender IBAN address
senderBankName       | String | Sender bank name
receiverIban     | String | Receiver IBAN address
receiverBankName     | String | Receiver bank name

### Required Scope

`PublicApi`: Basic Scope

## Get crypto withdraw history

> Request:

```http
GET /users/withdrawals/crypto?asset={asset}&page={page}&size={size}
```

> Response:

```json
[
  {
    "id": 0,
    "type": "Withdraw",
    "transactionHash": "0xd6c595d3a51bd90f3a9d13737c410bd29129115b0778dfb5d046652ee61940ad",
    "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "address": "0x4a9e4491c60ff88bb4253bd7f1c0d25b51138e96",
    "asset": "ETH",
    "amount": 1000,
    "fee": 0.001,
    "status": "Pending",
    "confirmedBlockCount": 0,
    "statusUpdateDate": "2021-12-13T14:01:37.047Z",
    "completeDate": "2021-12-13T14:01:37.047Z",
    "typicalPrice": 0,
    "network": "ETH"
  }
]

```

Filter users withdraw history with query parameters.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
asset | no | String | Symbol(ticker) of the asset
page | no | Int            | Page number
size    | no | Int         | Number of items per page

### Response Format

For the response format please refer to [Get Crypto Deposit History](/#get-crypto-deposit-history)

### Required Scope

`PublicApi`: Basic Scope

## Get fiat withdraw history

> Request:

```http
GET /users/withdrawals/fiat?asset={asset}&page={page}&size={size}
```

> Response:

```json
[
  {
    "id": 0,
    "type": "Withdraw",
    "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "asset": "TRY",
    "amount": 1000,
    "fee": 5,
    "status": "Pending",
    "statusUpdateDate": "2021-12-13T14:01:37.047Z",
    "completeDate": "2021-12-13T14:01:37.047Z",
    "typicalPrice": 0,
    "senderIban": "TR050202000000000001091100",
    "senderBankName": "Test Bankası",
    "receiverIban": "TR400006201493719805071327",
    "receiverBankName": "Test Bankası"
  }
]

```

Filter users withdraw history with query parameters.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
asset | no | String | Symbol(ticker) of the asset
page | no | Int            | Page number
size    | no | Int         | Number of items per page

### Response Format

For the response format please refer to [Get Fiat Deposit History](/#get-fiat-deposit-history)

### Required Scope

`PublicApi`: Basic Scope
## Initiate crypto withdraw

> Request:

```http
POST /users/withdrawals/crypto
```
```json
{
  "asset": "ETH",
  "amount": 1,
  "targetAddress": "0x4a9e4491c60ff88bb4253bd7f1c0d25b51138e96",
  "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "network": "ETH",
  "withdrawCryptoFee": 0.0001
}
```

> Response:

```json
{
  "id": 0,
  "type": "Withdraw",
  "transactionHash": "0xd6c595d3a51bd90f3a9d13737c410bd29129115b0778dfb5d046652ee61940ad",
  "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "address": "0x4a9e4491c60ff88bb4253bd7f1c0d25b51138e96",
  "asset": "ETH",
  "amount": 1000,
  "fee": 0.001,
  "status": "Pending",
  "confirmedBlockCount": 0,
  "statusUpdateDate": "2021-12-13T14:01:37.047Z",
  "completeDate": "2021-12-13T14:01:37.047Z",
  "typicalPrice": 0,
  "network": "ETH"
}
```

Initiate crypto withdraw order from the given parameters. In crypto withdraws target address must be in whitelist.
Withdraw amounts scale after stripping trailing zeros should not exceed allowed precision for the asset.
Precision of an asset can be reached from [Get a specific asset endpoint](/#get-a-specific-asset)




### Body Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
asset | yes | String     | Symbol(ticker) of the asset
amount    | yes | BigDecimal |
targetAddress    | yes | String | Address you want to withdraw
uuid    | yes | UUID | Created from client
network    | yes | String | Crypto network you want to use
withdrawCryptoFee    | yes | BigDecimal | Required for crypto withdraws. Dynamic withdraw crypto fee retrieved from [Get network configuration endpoint](/#get-network-configuration)

Available networks can be retrieved from [Get network configuration endpoint](/#get-network-configuration)

### Response Format

For the response format please refer to [Get Crypto Deposit History](/#get-crypto-deposit-history)
### Required Scope

`Withdraw`: Authorized to withdraw


## Initiate fiat withdraw

> Request:

```http
POST /users/withdrawals/fiat
```
```json
{
  "asset": "TRY",
  "amount": 0,
  "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "iban": "TR400006201493719805071327"
}
```

> Response:

```json
{
  "id": 0,
  "type": "Withdraw",
  "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "asset": "TRY",
  "amount": 1000,
  "fee": 0.001,
  "status": "Pending",
  "statusUpdateDate": "2021-12-13T14:01:37.047Z",
  "completeDate": "2021-12-13T14:01:37.047Z",
  "typicalPrice": 0,
  "senderIban": "TR050202000000000001091100",
  "senderBankName": "Test Bankası",
  "receiverIban": "TR400006201493719805071327",
  "receiverBankName": "Test Bankası"
}
```

Initiate fiat withdraw order from the given parameters.
Withdraw amounts scale after stripping trailing zeros should not exceed allowed precision for the asset.
Precision of an asset can be reached from [Get a specific asset endpoint](/#get-a-specific-asset)




### Body Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
asset | yes | String     | Symbol(ticker) of the asset
amount    | yes | BigDecimal |
uuid    | yes | UUID | Created from client
iban    | yes | String | IBAN address you want to withdraw

Available networks can be retrieved from [Get network configuration endpoint](/#get-network-configuration)

### Response Format

For the response format please refer to [Get Fiat Deposit History](/#get-fiat-deposit-history)

### Required Scope

`Withdraw`: Authorized to withdraw

## Cancel fiat withdraw

```http
POST /users/withdrawals/fiat/{transactionUuid}/cancel
```

Cancels withdraw order of the transaction uuid.

### URL Parameters

Parameter | Description
--------- | -----------
transactionUuid    | UUID of the transaction 

### Required Scope

`Withdraw`: Authorized to withdraw

## Get IBANs

> Request:

```http
GET /users/ibans
```

> Response:

```json
[
  {
    "id": 0,
    "iban": "TR400006201493719805071327",
    "bankName": "Test Bank",
    "accountName": "Account Name"
  }
]
```

Returns user's available IBANs.

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
id     | Long |
iban      | String | 
bankName  | String |
accountName | String |


### Required Scope

`PublicApi`: Basic Scope



## Get open orders

> Request: 

```http
GET /users/orders?baseAsset={baseAsset}&quoteAsset={quoteAsset}&orderType={orderType}&after={after}&before={before}&page={page}&size={size}
```

> Response:

```json
[
  {
    "id": 0,
    "price": 28410.00000000,
    "orderType": "Limit",
    "operationDirection": "Buy",
    "quantity": 1,
    "matchStatus": "None",
    "executedQuantity":  0.03900000,
    "averageMatchPrice": 28408.20300000,
    "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "baseAsset": "ETH",
    "quoteAsset": "TRY",
    "orderTime": "2021-12-13T18:18:52.345Z",
    "stopPrice": null
  }
]
```

Get list of user's Active orders. Orders can be filtered with query parameters.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAsset | no | String     | Symbol(ticker) of the base asset
quoteAsset | no | String     | Symbol(ticker) of the quote asset
orderType    | no | **OrderType** | _Market_, _Limit_, _StopLimit_, _FillOrKill_, _ImmediateOrCancel_
after    | no | Instant
before    | no | Instant
page    | no | Int
size    | no | Int


### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
id     | Long | Unique identifier of the order
price      | BigDecimal | price of the order
orderType  | **OrderType** | _Market_, _Limit_, _StopLimit_, _FillOrKill_, _ImmediateOrCancel_
operationDirection | String | Sell, Buy
quantity     | BigDecimal | Quantity of the asset in the order
orderStatus      | **OrderStatus** | _Active_, _Canceled_, _Completed_
matchStatus  | String | None, Partial, Full
executedQuantity | String | Executed quantity of the asset in the order
averageMatchPrice     | Long | Avarage matched price of the order
uuid      | UUID | UUID of the order
baseAsset  | String | Symbol(ticker) of the base asset
quoteAsset | String | Symbol(ticker) of the quote asset
orderTime     | String | ISO8601 Order creation date
stopPrice      | BigDecimal | Stop price of the order if exist

### [Order Types] (https://en.wikipedia.org/wiki/Order_(exchange)#Conditional_orders)

### Required Scope

`PublicApi`: Basic Scope



## Get order history

> Request: 

```http
GET /users/orders/history?baseAsset={baseAsset}&quoteAsset={quoteAsset}&orderType={orderType}&after={after}&before={before}&page={page}&size={size}
```

> Response:

```json
[
  {
    "id": 0,
    "price": 28410.00000000,
    "orderType": "Limit",
    "operationDirection": "Buy",
    "quantity": 1,
    "matchStatus": "None",
    "executedQuantity":  0.03900000,
    "averageMatchPrice": 28408.20300000,
    "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "baseAsset": "ETH",
    "quoteAsset": "TRY",
    "orderTime": "2021-12-13T18:18:52.345Z",
    "stopPrice": null
  }
]
```

Get list of user's Completed and Cancelled orders. Orders can be filtered with query parameters.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAsset | no | String     | Symbol(ticker) of the base asset
quoteAsset | no | String     | Symbol(ticker) of the quote asset
orderType    | no | **OrderType** | _Market_, _Limit_, _StopLimit_, _FillOrKill_, _ImmediateOrCancel_
after    | no | Instant
before    | no | Instant
page    | no | Int
size    | no | Int


### Response Format

For the response format please refer to [Get open orders](/#get-open-orders)

### Required Scope

`PublicApi`: Basic Scope

## Get order by UUID

> Request:

```http
GET /users/orders/{uuid}
```

> Response:

```json
{

  "id": 0,
  "price": null,
  "orderType": "Market",
  "operationDirection": "Sell",
  "quantity": 1,
  "orderStatus": "Completed",
  "matchStatus": "Full",
  "executedQuantity": 1,
  "averageMatchPrice": 28410.45000000,
  "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "baseAsset": "ETH",
  "quoteAsset": "TRY",
  "orderTime": "2021-12-13T18:47:13.576Z",
  "stopPrice": null,
}
```

Get users order detail by order UUID.

### URL Parameters

Parameter | Description
--------- | -----------
uuid    | Order UUID

### Response Format

For the response format please refer to [Get open orders](/#get-open-orders)

### Required Scope

`PublicApi`: Basic Scope

## Create order

> Request:

```http
PUT /users/orders
```

```json
{
  "baseAsset": "ETH",
  "quoteAsset": "TRY",
  "orderType": "Limit",
  "operationDirection": "Buy",
  "quantity": 1,
  "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "limit": 28410.00000000,
  "stopLimit": null
}
```

> Response:

```json
{
  "matchCount": 2,
  "quantity": 0,
  "executedQuantity": 0,
  "averageMatchPrice": null
}
```

Creates a new order.



### Body Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAsset | yes | String     | Symbol(ticker) of the base asset
quoteAsset | yes | String     | Symbol(ticker) of the quote asset
orderType    | yes | **OrderType** | _Market_, _Limit_, _StopLimit_, _FillOrKill_, _ImmediateOrCancel_
operationDirection    | yes | **OperationDirection** | _Sell_, _Buy_
quantity    | yes | BigDecimal
uuid    | yes | UUID | Created from client
limit    | no | BigDecimal | Limit value for limit order
stopLimit    | no | BigDecimal | stop limit value for StopLimit order


### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
matchCount        | Int | 
quantity          | BigDecimal | 
executedQuantity  | BigDecimal |
averageMatchPrice | BigDecimal | 

### Required Scope

`Trade`: Authorized to give orders

## Cancel orders

> Request

```http
POST /users/orders/cancel
```

```json
{
  "baseAsset": "ETH",
  "quoteAsset": "TRY",
  "operationDirection": "Buy",
  "priceBelow": 30000,
  "priceAbove": 28000
}
```

Cancel filtered orders with body parameters.



### Body Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAsset | no | String     | Symbol(ticker) of the base asset
quoteAsset | no | String     | Symbol(ticker) of the quote asset
operationDirection    | no | **OperationDirection** | _Sell_, _Buy_
priceBelow    | no | BigDecimal | Order price below
priceAbove | no | BigDecimal | Order price above

### Required Scope

`Trade`: Authorized to give orders

## Cancel order

> Request

```http
POST /users/orders/{uuid}/cancel
```

Cancels the order with given uuid.

### URL Parameters

Parameter | Description
--------- | -----------
uuid    | Order UUID

### Required Scope

`Trade`: Authorized to give orders



##Get deposit & withdraw restrictions

> Request

```http
GET /users/restrictions?asset={asset}&type={type}
```

> Response:

```json
{
  "dailyTotal": 1000000000,
  "dailyRemaining": 1000000000,
  "monthlyTotal": 1000000000,
  "monthlyRemaining": 1000000000
}
```

Get user's daily and monthly external transaction restrictions for the specified asset.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
asset | yes | String     | Symbol(ticker) of the asset
type | yes | **ExternalTransactionType** | _Withdraw_, _Deposit_

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
dailyTotal        | BigDecimal | Daily total restriction
dailyRemaining          | BigDecimal | Daily remaining restriction
monthlyTotal  | BigDecimal | Monthly total restriction
monthlyRemaining | BigDecimal | Monthly remaining restriction

### Required Scope

`PublicApi`: Basic Scope




## Get user transactions

> Request:

```http
GET /users/transactions?baseAsset={baseAsset}&quoteAsset={quoteAsset}&operationDirection={operationDirection}&orderUUID={orderUUID}&after={after}&before={before}&page={page}&size={size}
```

> Response:

```json
[
  {
    "hash": 2312321,
    "baseAsset": "ETH",
    "quoteAsset": "TRY",
    "orderUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "transactionDate": "2021-12-13T19:43:07.730Z",
    "matchedQuantity": 0.5,
    "matchedPrice": 28410.45000000,
    "orderType": "Limit",
    "feeAmount": 0.000450000,
    "buyer": true
  }
]

```

Filter users transactions with query parameters.



### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAsset | no | String     | Symbol(ticker) of the base asset
quoteAsset | no | String     | Symbol(ticker) of the quote asset
operationDirection    | no | **OperationDirection** | _Sell_, _Buy_
orderUUID    | no | UUID  | UUID of the order
after    | no | Instant 
before    | no | Instant
page | no | Int            | Page number
size    | no | Int         | Number of items per page

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
hash        | Int | Unique identifier hash for the user transaction
baseAsset     | String | Symbol(ticker) of the base asset
quoteAsset  | String | Symbol(ticker) of the quote asset
orderUUID | UUID | UUID of the order
transactionDate        | String | ISO8601 Date of the transaction
matchedQuantity          | BigDecimal | Matched quantity of the transaction
matchedPrice  | BigDecimal | Matched price of the transaction
orderType    | **OrderType** | _Market_, _Limit_, _StopLimit_, _FillOrKill_, _ImmediateOrCancel_
feeAmount        | BigDecimal | Fee amount of the transaction
buyer          | Boolean | True if it is a buy order

### Required Scope

`PublicApi`: Basic Scope

## Get daily total balance

> Request:

```http
GET /users/daily/total-balance?after={after}&before={before}
```

> Response:

```json
[
  {
      "totalAmountTry": 0.00,
      "totalAmountUsd": 0.00,
      "date": "2022-08-08T00:00:00Z"
  },
  {
      "totalAmountTry": 130.00,
      "totalAmountUsd": 7.28,
      "date": "2022-08-09T00:00:00Z"
  }
]
```

Filter users daily total positions with query parameters. Returns the data showing the balance field on the dashboard.



### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
after    | no | Instant
before    | no | Instant

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
totalAmountTry    | BigDecimal | Total balance value in TRY
totalAmountUsd    | BigDecimal | Total balance value in USD
date  | String | ISO8601 date of the snapshot
### Required Scope

`PublicApi`: Basic Scope

## Get daily positions

> Request:

```http
GET /users/daily/balance?after={after}&before={before}
```

> Response:

```json
[
  {
    "assets": {
      "ETH": {
          "amount": 0.00,
          "amountTry": 0.00,
          "amountUsd": 0.00
      },
      "BNB": {
          "amount": 0.00,
          "amountTry": 0.00,
          "amountUsd": 0.00
      },
      "TRY": {
          "amount": 0.00,
          "amountTry": 0.00,
          "amountUsd": 0.00
      }
    },
    "date": "2022-08-08T00:00:00Z"
  }
]
```

Filter users daily positions with query parameters. Returns data showing daily balance graph.



### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
after    | no | Instant
before    | no | Instant

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
amount        | BigDecimal | Amount of the asset
amountTry     | BigDecimal | TRY value of the asset with the amount
amountUsd  | BigDecimal | USD value of the asset with the amount

### Required Scope

`PublicApi`: Basic Scope

## Get wallets

> Request:

```http
GET /users/wallets
```

> Response:

```json
[
  {
    "id": 239560,
    "asset": "ETH",
    "reservedAmount": 0E-16,
    "availableAmount": 0E-16
  },
  {
    "id": 239562,
    "asset": "BTC",
    "reservedAmount": 0E-16,
    "availableAmount": 0E-16
  },
  {
    "id": 239555,
    "asset": "TRY",
    "reservedAmount": 0E-16,
    "availableAmount": 120.0000000000000000
  }
]
```

Get wallets of user.

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
id        | Long | Unique identifier of the wallet
asset     | String | Symbol(ticker) of the asset
reservedAmount  | BigDecimal | Reserved amount of the wallet due to open order, etc.
availableAmount  | BigDecimal | Amount available to use

### Required Scope

`PublicApi`: Basic Scope


## Get wallet by asset

> Request:

```http
GET /users/wallets/{asset}
```

> Response:

```json
{
  "id": 239555,
  "asset": "TRY",
  "reservedAmount": 0E-16,
  "availableAmount": 120.0000000000000000
}
```

Get position of user by asset id.

### URL Parameters

Parameter | Description
--------- | -----------
asset   | Symbol(ticker) of the asset

### Response Format

For the response format please refer to [Get wallets](/#get-wallets)

### Required Scope

`PublicApi`: Basic Scope

## Get or Create address for wallet

> Request:

```http
GET /users/wallets/{asset}/network/{network}/address
```

> Response:

```json
{
  "walletId": 239554,
  "asset": "ETH",
  "address": "0x4a9e4491c60ff88bb4253bd7f1c0d25b51138e96"
}
```

Get cryptocurrency address for wallet with the selected network. If not exists, create address for wallet with the selected network.

### URL Parameters

Parameter | Description
--------- | -----------
asset  | Symbol(ticker) of the asset
network   | **Available Networks**

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
walletId  | Long | Unique identifier of the wallet
asset     | String | Symbol(ticker) of the asset
address   | String | Crypto deposit address

- **Available Networks**: Available networks can be retrieved from [Get network configuration endpoint](/#get-network-configuration)

### Required Scope

`PublicApi`: Basic Scope

## Create socket key

> Request

```http
POST /users/socket/keys
```

> Response:

```json
{
  "key": "b12f3943-a90d-4ba5-9717-test0901b316s"
}
```

Creates a key for connecting to the socket. With this key, the user listens for specific data.

### Response Format

Field            | Type      | Description
---------------- | --------- | -----------
key  | String | Socket key

### Required Scope

`PublicApi`: Basic Scope

## Delete socket key

> Request:

```http
DELETE /users/socket/keys
```

Deletes the socket key.

### Required Scope

`PublicApi`: Basic Scope


# Socket Usage

> Socket Connection:

```js
const io = require("socket.io-client");
const socket = io(
    "https://socket.bitronit.com",
    {
        transports: ['websocket']
    }
);

socket.on('connect', () => {
    socket.emit('join', ${CHANNEL_NAME})
    socket.on({CHANNEL_NAME}, (data) => {
        // Data is retrieved
    })
});
```

> Connection to specific room:

```js
const io = require("socket.io-client");
const socket = io(
    "https://socket.bitronit.com",
    {
        transports: ['websocket']
    }
);

socket.on('connect', () => {
    console.log('connected')

    socket.emit('join', "ETHTRY-orderbook-3")
    socket.on("orderbook", data => {
        // Data is retrieved
    })

})
```

> Orderbook for every group(based on decimal precision):

```markdown
${TICKER}-orderbook-0
${TICKER}-orderbook-1
${TICKER}-orderbook-2
${TICKER}-orderbook-3
${TICKER}-orderbook-4
${TICKER}-orderbook-5
${TICKER}-orderbook-6
${TICKER}-orderbook-7
${TICKER}-orderbook-8
```

> "orderbook" Channel Data Model:

```js
ex: ['ETH', 2, 'TRY', 7, '2022-01-10T08:04:14.604999Z', 3, { '44295.246': 0.00216, '44292.945': 0 }, { '44382.780': 0.00341, '44395.089': 0 }, 4033464037]
[baseAsset, baseAsset, quoteAsset, quoteAsset, timestamp, scale, buy, sell, checksum]
```

> Current candlesticks for all periods:

```markdown
${TICKER}-candlestick-1
${TICKER}-candlestick-5
${TICKER}-candlestick-15
${TICKER}-candlestick-30
${TICKER}-candlestick-60
${TICKER}-candlestick-240
${TICKER}-candlestick-1440
${TICKER}-candlestick-10080
${TICKER}-candlestick-43200
```

> "candlestick" Channel Data Model:

```js
ex: ['2022-01-10T08:55:00Z', 44090.032, 44090.032, 44090.032, 44090.032, 0]
[opentime, open, high, low, close, volume]
```

**Socket URL:** **https://socket.bitronit.com**

There are 10 channels available in Bitronit Socket.

**Keyed** socket channels provides user specific data through channel.

Channel     | Type        | Description
--------  | ----------- | -----------
keyed-position-update    |     Keyed        | Changes in users wallet
keyed-user-transaction-execute    |     Keyed        | Transaction history for user
keyed-external-transaction-update    |    Keyed         | Deposit/withdraw changes for user
keyed-order-create    |      Keyed       | Order creation for user
keyed-order-update    |     Keyed        | Order updates for user
candlestick    |      General       | Candlestick data for graph
orderbook    |     General        | Retrieving orderbook
trade    |     General        | Recent trades
all-ticker    |      General       | Retrieving ticker data for all tickers

**Keyed** channels are used with the key that is retrieved from POST /users/socket/keys endpoint.

**Keyed channel:**

_${key}-position-update_

> "keyed-position-update" Channel Data Model:

```js
ex: [60948, 14183, 7, 'TRY', {positionId: 61195, totalAmount: 2209.98959511, reservedAmount: 0, availableAmount: 2209.98959511}, [14183]]
[walletId, userId, assetId, asset, positionDetail, userIds]
```

> "keyed-user-transaction-execute" Channel Data Model:

```js
ex: [2, false, 0.05209903, 51329.093, 0.00203, 'Limit', '4955ca43-7…', 7,  '2022-01-05T11:10:58.114469Z', 11704]
[baseAsset, buyer, feeAmount, matchedPrice, matchedQuantity, orderType, orderUUID, quoteAsset, transactionDate, userId]
```

> "keyed-external-transaction-update" Channel Data Model:

```js
ex: ['0x9e8…', 0.0004, 'ETH', 2, '2021-11-24T17:49:58.084900Z', 0, 0, false, 11893460, 'ETH', null, null, null, null, 'Success', '2021-11-24T17:49:58.084899Z', null, '6b3c9a80-7…', 'Withdraw',  1.6858248, 11704]
[address, amount, asset, assetId, completeDate, confirmedBlockCount, fee, fiat, id, network, receiverBankName, status, receiverIban, senderBankName, senderIban, statusUpdateDate ,transactionHash, transactionUUID, type, typicalPrice, userId]
```

> "keyed-order-create" Channel Data Model:

```js
ex: [null, 2, 0, 59191684, 1988.84447184, 'Buy', 'Market', null, 0.00405, 7, null, 14183, null, 'dbfded9c-d...']
[activated, baseAsset, executedQuantity, id, maxVolume, operationDirection, orderType, price, quantity, quoteAsset, stopPrice, userId, userType, uuid]
```

> "keyed-order-update" Channel Data Model:

```js
ex: ['Market', 'a85c0a90-1...', 14183, 'Completed', 0.00501, 44140.74316766]
[orderType, uuid, userId, status, executedQuantity, averageMatchPrice]
```

> "trade" Channel Data Model:

```js
ex: ['ETH', 2, null, false, 'e9f3b404-6', 44145.291, 0.00211, 'TRY', 7, "2022-01-09T11:30:25.896044Z"]
[baseAsset, baseAsset, id, isBuyerTaker, matchId, matchedPrice, matchedQuantity, quoteAsset, quoteAsset, time]
```

> "all-ticker" Channel Data Model:

```js
ex: [ 'LINK', 'TRY', 357.94, 363.54, 323.39, 103109.12208, 5.91, 19.96 ]
[baseAsset, quoteAsset, currentPrice, highestPrice, lowestPrice, dailyVolume, dailyChange, dailyNominalChange]
```

# Errors

## Client Errors

| HTTP Status Code | Error Code                         | Error Message                                              | Reason and Actions to fix
|------------------|-------------------------|-----------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 400              | INVALID_LIMIT       | Not valid limit size: {$limit}, it should be in [1, 500]              | This error message is thrown when limit is bigger than 500 while getting candlesticks. In order to fix, limit should be in 1, 500 range. Please check your limits for a valid request.                                                                                                  |
| 401              | SIGNATURE UNAUTHORIZED  | Signature: {$signature} is not valid.                                 | This error message is thrown when the signature that is retrieved from the “Signature” header is not true. Please take a look at the [authentication section](#authentication) of the api documentation for the correct way to utilize Bitronit public api.   |
| 401              | SIGNATURE NOT_FOUND     | Signature not found in the request headers                            | This error message is thrown when the signature is not found in the request headers. Please take a look at the [authentication section](/#authentication) of the api documentation for the correct way to utilize Bitronit public api.                         |
| 401              | API_KEY_NOT_FOUND       | Api-key not found.                                                    | This error message is thrown when the API Key is not found in the request headers. Please take a look at the section [authentication section](/#authentication) of the api documentation for the correct way to utilize Bitronit public api.                   |
| 401              | IP_ADDRESS NOT_ALLOWED  | IP address $ipAddress is restricted.                                  | This error message is thrown when the request is sent from an IP address that is not added to IP whitelist. Please take a look at the [limits section](/#limits) of the api documentation for the correct way to utilize Bitronit public api.                  |
| 401              | API_KEY NOT_ENABLED     | Api-key with id: $id is not enabled.                                  | This error message is thrown when API Keys status is disabled or expired. Please check the validity of your API Key.                                                                                                                                                                    |
| 404              | ADDRESS NOT_FOUND       | Address: {$address} not found in whitelist.                           | This error message is thrown while initiating crypto withdraw. If target address is not in whitelist, exception is thrown. Please add address to your whitelist in order to withdraw to the target account.                                                                                                                                                                                                                                |
| 404              | ASSET_NOT_FOUND         | Asset not found.                                                      | This error message is thrown when getting an asset with the wrong ticker. Please check the tickers name in your request.                                                                                                                                                                |
| 400              | WITHDRAW_IS NOT_ALLOWED FOR_ASSET| Withdraw is not allowed for asset: $assetId                  | This error message is thrown while initiating withdraw with a network that is not supported in Bitronit. Please check asset and network in order to proceed with your request.                                                                                                          |
| 400              | WITHDRAW_AMOUNT PRECISION_ERROR  | Amount scale: $scale exceeded allowed ${precision} for the ${ticker}| This error message is thrown while initiating withdraw, amount scale exceeds allowed precision. Please check amount and precision to proceed with your transaction.                                                                                                                     |
| 404              | NETWORK_CONFIG NOT_FOUND| Network $network for asset $asset not found. Fiat: $fiat              | This error message is thrown while initiating withdraw. asset is not supported with the network config. Please check assets network support in Bitronit to find available networks for your withdraw transaction.                                                                     |
| 403              | WITHDRAW_IS NOT_ALLOWED FOR_USER | Withdraw is not allowed for userId: $userId.                 | This error message is thrown while initiating withdraw with a sub user. Please try again with parent account.                                                                                                                                                                           |
| 403              | TRANSFER_IS NOT_ALLOWED FOR_USER | Transfer is not allowed for userId: $userI                   | This error message is thrown while trying to transfer between main user and sub user, if the target account is not configured as a sub user. Please enable sub-user type for the target user.                                                                                           |
| 403              | TRANSFER_NOT ALLOWED    | Transfer only allowed between main user and its sub users             | This error message is thrown while trying to transfer with an account not marked as sub user. Transfers are only allowed between main user and its sub users.                                                                                                                           |
| 400              | ALREADY CANCELED        | Order was already canceled                                            | This error message is thrown while trying to cancel an order that was already cancelled.                                                                                                                                                                                                |
| 400              | ALREADY COMPLETED       | Order was already matched                                             | This error message is thrown while trying to cancel an order that was already matched.                                                                                                                                                                                                  |
| 404              | NOT_FOUND               | Version not found (baseAsset,quoteAsset,scale)                        | This error message is thrown while trying to retrieve orderbook data with wrong parameters. Please control baseAsset, quoteAsset and scale parameters.                                                                                                                            |  
| 404              | PAIR_NOT_FOUND          | Trading pair not found.                                               | This error is thrown while trying to retrieve trading pair by wrong asset. Please check assets in your request.                                                                                                                                                                     |
| 404              | WALLET_NOT_FOUND        | Wallet not found                                                      | This error is thrown when wallet is not found for given asset                           |
| 404              | IBAN_NOT_FOUBD        | Iban: {$iban} not found in user ibans                                   | This error is thrown when iban in the request is not found in user's ibans for the fiat withdraw process.

[HTTP Status Code Descriptions](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)
