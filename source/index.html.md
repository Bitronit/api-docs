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

- The base endpoint is: <b> https://bitronit.com/api </b>
- All endpoints successful requests returns either a JSON object or array.
- There are `PUBLIC` and `SIGNED` endpoints. 
- `PUBLIC` endpoints don't require Authentication and Signature Headers. 
- `SIGNED` endpoints require Authentication and Signature Headers.

> Error response:

```json
{
  "error": "Not Found",
  "message": "USER_NOT_FOUND",
  "path": "/users/11704/wallets/40440/network/LTC/adress",
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
- You must send symbol parameter in `BTCTRY` format. 

## Limits

### IP Limits

- Users can have at most 30 API-keys.
- An API-key can have at most 4 IP restrictions.
- IP's should be in public range. Private ranges are not allowed.
- <b> The limits on the API are based on the IPs, not the API keys. </b>

### Rate Limits

- Hitting our rate limits will result in HTTP 429 errors.

## Authentication

- For `SIGNED` requests, the following headers should be sent with the request:

  - `Authentication`: Your API key as bearer token
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
$ echo -n "baseAssetId=5&quoteAssetId=6&scale=3" | openssl dgst -sha256 -hmac "c0bad7a7eb95876bcd646bcf7f42e39ff1dd75311edb4f4df84de3e41f3b3c5d" -binary | base64
    (stdin)= yDyq8EkvBoOm+GKKxch4TwD6K0L0q5KaTNLVQv8F0rg=
```
> **curl command:**

```shell
(HMAC SHA256)
$ curl -H "Authorization: Bearer 966304e1-9be0-4d79-a1b0-95d069a7bfaf" -H "Signature: yDyq8EkvBoOm+GKKxch4TwD6K0L0q5KaTNLVQv8F0rg=" -X GET 'https://bitronit.com/api/orders/group?baseAssetId=5&quoteAssetId=6&scale=3'

```

**GET /orders/group**

Parameter     | Value
---------     | -----
baseAssetId   | 2
quoteAssetId  | 7
scale         | 2


- queryString:

  baseAssetId=5&quoteAssetId=6&scale=3


**POST /users/{userId}/orders/cancel**

> **HMAC SHA256 signature:**

```shell
$ echo -n '{"priceBelow": 12.5, "priceAbove": 7.8, "operationDirection": "Buy", "baseAssetId": 3, "quoteAssetId": 7}' | openssl dgst -sha256 -hmac "c0bad7a7eb95876bcd646bcf7f42e39ff1dd75311edb4f4df84de3e41f3b3c5d" -binary | base64
    (stdin)= xfxO7ec5WyzUleFLNjqFyUmsKOvLnTxYCvYXb7SNkfQ=
```
> **curl command:**

```shell
(HMAC SHA256)
$ curl -H "Authorization: Bearer 966304e1-9be0-4d79-a1b0-95d069a7bfaf" -H "Signature: xfxO7ec5WyzUleFLNjqFyUmsKOvLnTxYCvYXb7SNkfQ=" -X POST 'https://bitronit.com/api/users/5/orders/cancel' -d '{"priceBelow":12.5,"priceAbove":7.8,"operationDirection":"Buy","baseAssetId":3,"quoteAssetId":7}'

```


Parameter           | Value
---------           | -----
priceBelow          | 12.5
priceAbove          | 7.8
operationDirection  | Buy
baseAssetId         | 3
quoteAssetId        | 7

- requestBody:

{"priceBelow": 12.5, "priceAbove": 7.8, "operationDirection": "Buy", "baseAssetId": 3, 
"quoteAssetId": 7}

# API Key Endpoint

## Get API Key Info

> Request:

```http
GET /api-key/info
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

Returns userId and permissions info for API Key

### Required Scope

`PublicApi`: Basic Scope


# Asset Endpoints

## Get assets

> Request:

```http
GET /assets
```
> Response:

```json
[
  {
    "id": 0,
    "ticker": "string",
    "fullName": "string",
    "circulatingSupply": 0,
    "circulatingSupplyUpdateDate": "2021-12-13T12:54:04.030Z",
    "displayOrder": 0,
    "fiat": true,
    "precision": 0
  }
]
```

Returns all assets.

### Public Request

## Get a specific asset 

> Request:

```http
GET /assets/{ticker}
```

> Response:

```json
{
  "id": 0,
  "ticker": "string",
  "fullName": "string",
  "circulatingSupply": 0,
  "circulatingSupplyUpdateDate": "2021-12-13T12:54:04.030Z",
  "displayOrder": 0,
  "fiat": true,
  "precision": 0
}
```

Returns the assets detail.

### URL Parameters

Parameter | Description
--------- | -----------
ticker    | Symbol of asset

### Public Request


## Get network configuration

> Request:

```http
GET /crypto-network
```

> Response:

```json
[
  {
    "id": 0,
    "network": "BTC",
    "assetId": 0,
    "minConfirmations": 0,
    "depositEnabled": true,
    "withdrawEnabled": true,
    "minAddressLength": 0,
    "maxAddressLength": 0,
    "addressValidationRegex": "string",
    "explorerAddressUrl": "string",
    "explorerTransactionUrl": "string",
    "displayOrder": 0,
    "withdrawFee": 0,
    "minWithdrawMultiplier": 0,
    "name": "BTC"
  }
]
```

Returns the crypto network detail(s).

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
assetId | false | Long |

### Public Request


## Get crypto withdraw config

> Request:

```http
GET /assets/{assetId}/network/{network}/crypto-withdraw-config
```

> Response:

```json
{
  "withdrawEnabled": true,
  "withdrawFee": 0,
  "minWithdrawMultiplier": 0
}
```

Returns the crypto withdraw config for the asset with given network.

### URL Parameters

Parameter | Description
--------- | -----------
assetId    | 
network    | Crypto Network

Available networks can be retrieved from [Get network configuration endpoint](https://docs.bitronit.com/#get-network-configuration)


### Public Request


## Get fiat withdraw config

> Request:

```http
GET /assets/{assetId}/network/{network}/fiat-withdraw-config
```

> Response:

```json
{
  "withdrawEnabled": true,
  "withdrawFee": 0,
  "minWithdrawMultiplier": 0
}
```

Returns the fiat withdraw config for the asset.

### URL Parameters

Parameter | Description
--------- | -----------
assetId    |


### Public Request


# Candlestick Endpoints

## Get candlesticks

> Request:

```http
Limit, period calculation:
  For 1 week candlestick data,
  period = 240(4 hours),
  limit = 42
  42*4 = 168(1 week)
  
GET /candlesticks?baseAssetId={baseAssetId}&quoteAssetId={quoteAssetId}&period={period}&startTime={startTime}&endTime={endTime}&limit={limit}
```

> Response:

```shell
[
  [baseAssetId, quoteAssetId, baseAsset, quoteAsset, opentime, open, high, low, close, volume, closetime],
  [Long, Long, String, String, Timestamp, BigDecimal, BigDecimal, BigDecimal, BigDecimal, BigDecimal, TimeStamp],
  [1, 4, "BTC", "USDT", 1576669680000, 2, 2, 2, 2, 0, 1576669739999],
  ...
]
```

Filter or limit the candlesticks with query parameters.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAssetId | true | Long     | 
quoteAssetId | true | Long    | 
period    | true | Int        | Period of the candlestick in minutes.
startTime    | false | Long   | 
endTime    | false | Long     | 
limit    | false | Int        | Maximum data number for candlestick.

### Public Request

# External Transaction Endpoints

## Get users deposit history

> Request:

```http
GET /users/{userId}/deposits?assetId={assetId}&fiat={fiat}&page={page}&size={size}&sort={sort}
```

> Response:

```json
{
  "externalTransactions": [
    {
      "id": 0,
      "type": "string",
      "transactionHash": "string",
      "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "address": "string",
      "asset": "string",
      "assetId": 0,
      "amount": 0,
      "fee": 0,
      "userId": 0,
      "status": "Waiting",
      "confirmedBlockCount": 0,
      "statusUpdateDate": "2021-12-13T14:01:37.047Z",
      "completeDate": "2021-12-13T14:01:37.047Z",
      "typicalPrice": 0,
      "fiat": true,
      "senderIban": "string",
      "senderBankName": "string",
      "receiverIban": "string",
      "receiverBankName": "string",
      "statusMessage": "string"
    }
  ]
}
```

Filter users deposit history with query parameters.

### URL Parameters

Parameter | Description
--------- | -----------
userId    | 

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
assetId | false | Long        |
fiat    | false | Boolean     |
page | false | Int            | Page number
size    | false | Int         | Number of data per page
sort    | false | String      | Variable to sort,sorting type(e.g. `id,asc`)

### Required Scope

`PublicApi`: Basic Scope

## Get users deposit history count

> Request:

```http
GET /users/{userId}/deposits/count?assetId={assetId}&fiat={fiat}
```

> Response:

```json
{
  "count": 0
}
```

Count of filtered users deposit history with query parameters.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
assetId | false | Long |
fiat    | false | Boolean |

### Required Scope

`PublicApi`: Basic Scope

## Get users withdraw history

> Request:

```http
GET /users/{userId}/withdrawals?assetId={assetId}&fiat={fiat}&page={page}&size={size}&sort={sort}
```

> Response:

```json
{
  "externalTransactions": [
    {
      "id": 0,
      "type": "string",
      "transactionHash": "string",
      "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "address": "string",
      "asset": "string",
      "assetId": 0,
      "amount": 0,
      "fee": 0,
      "userId": 0,
      "status": "Waiting",
      "confirmedBlockCount": 0,
      "statusUpdateDate": "2021-12-13T14:09:53.609Z",
      "completeDate": "2021-12-13T14:09:53.609Z",
      "typicalPrice": 0,
      "fiat": true,
      "senderIban": "string",
      "senderBankName": "string",
      "receiverIban": "string",
      "receiverBankName": "string",
      "statusMessage": "string"
    }
  ]
}
```

Filter users withdraw history with query parameters.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
assetId | false | Long |
fiat    | false | Boolean |
page | false | Int            | Page number
size    | false | Int         | Number of data per page
sort    | false | String      | Variable to sort,sorting type(e.g. `id,asc`)

### Required Scope

`PublicApi`: Basic Scope

## Get users withdraw history count

> Request:

```http
GET /users/{userId}/withdrawals/count?assetId={assetId}&fiat={fiat}
```

> Response:

```json
{
  "count": 0
}
```

Count of filtered users withdraw history with query parameters.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
assetId | false | Long |
fiat    | false | Boolean |

### Required Scope

`PublicApi`: Basic Scope

## Initiate crypto withdraw

> Request:

```http
POST /users/{userId}/withdrawals/crypto
```
```json
{
  "assetId": 0,
  "amount": 0,
  "targetAddress": "string",
  "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "network": "string",
  "withdrawCryptoFee": 0
}
```

> Response:

```json
{
  "id": 0,
  "type": "string",
  "transactionHash": "string",
  "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "address": "string",
  "asset": "string",
  "assetId": 0,
  "amount": 0,
  "fee": 0,
  "userId": 0,
  "status": "Waiting",
  "confirmedBlockCount": 0,
  "statusUpdateDate": "2021-12-13T14:09:53.609Z",
  "completeDate": "2021-12-13T14:09:53.609Z",
  "typicalPrice": 0,
  "fiat": true,
  "senderIban": "string",
  "senderBankName": "string",
  "receiverIban": "string",
  "receiverBankName": "string",
  "statusMessage": "string"
}
```

Initiate crypto withdraw order from the given parameters. In crypto withdraws target address must be in whitelist.
Withdraw amounts scale after stripping trailing zeros should not exceed allowed precision for the asset.
Precision of an asset can be reached from [Get a specific asset endpoint](https://docs.bitronit.com/#get-a-specific-asset)


### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Body Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
assetId | true | Long |
amount    | true | BigDecimal |
targetAddress    | true | String | Address you want to withdraw
uuid    | true | UUID | Created from client
network    | true | String | Crypto network you want to use
withdrawCryptoFee    | true | BigDecimal | Required for crypto withdraws. Dynamic withdraw crypto fee retrieved from [Get network configuration endpoint](https://docs.bitronit.com/#get-network-configuration)

Available networks can be retrieved from [Get network configuration endpoint](https://docs.bitronit.com/#get-network-configuration)

### Required Scope

`Withdraw`: Authorized to withdraw


## Initiate fiat withdraw

> Request:

```http
POST /users/{userId}/withdrawals/fiat
```
```json
{
  "assetId": 0,
  "amount": 0,
  "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "ibanId": "string"
}
```

> Response:

```json
{
  "id": 0,
  "type": "string",
  "transactionHash": "string",
  "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "address": "string",
  "asset": "string",
  "assetId": 0,
  "amount": 0,
  "fee": 0,
  "userId": 0,
  "status": "Waiting",
  "confirmedBlockCount": 0,
  "statusUpdateDate": "2021-12-13T14:09:53.609Z",
  "completeDate": "2021-12-13T14:09:53.609Z",
  "typicalPrice": 0,
  "fiat": true,
  "senderIban": "string",
  "senderBankName": "string",
  "receiverIban": "string",
  "receiverBankName": "string",
  "statusMessage": "string"
}
```

Initiate fiat withdraw order from the given parameters.
Withdraw amounts scale after stripping trailing zeros should not exceed allowed precision for the asset.
Precision of an asset can be reached from [Get a specific asset endpoint](https://docs.bitronit.com/#get-a-specific-asset)


### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Body Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
assetId | true | Long |
amount    | true | BigDecimal |
uuid    | true | UUID | Created from client
ibanId    | true | Long | IBAN you want to withdraw

Available networks can be retrieved from [Get network configuration endpoint](https://docs.bitronit.com/#get-network-configuration)

### Required Scope

`Withdraw`: Authorized to withdraw

## Transfer between accounts

> Request:

```http
POST /users/{userId}/transfer
```
```json
{
  "assetId": 0,
  "amount": 0,
  "targetUserId": 0,
  "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "type": "DepositToTarget"
}
```

> Response:

```json
{
  "withdrawRecord": {
    "id": 0,
    "type": "string",
    "transactionHash": "string",
    "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "address": "string",
    "asset": "string",
    "assetId": 0,
    "amount": 0,
    "fee": 0,
    "userId": 0,
    "status": "Waiting",
    "confirmedBlockCount": 0,
    "statusUpdateDate": "2021-12-13T14:21:18.295Z",
    "completeDate": "2021-12-13T14:21:18.295Z",
    "typicalPrice": 0,
    "fiat": true,
    "senderIban": "string",
    "senderBankName": "string",
    "receiverIban": "string",
    "receiverBankName": "string",
    "statusMessage": "string"
  },
  "depositRecord": {
    "id": 0,
    "type": "string",
    "transactionHash": "string",
    "transactionUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "address": "string",
    "asset": "string",
    "assetId": 0,
    "amount": 0,
    "fee": 0,
    "userId": 0,
    "status": "Waiting",
    "confirmedBlockCount": 0,
    "statusUpdateDate": "2021-12-13T14:21:18.295Z",
    "completeDate": "2021-12-13T14:21:18.295Z",
    "typicalPrice": 0,
    "fiat": true,
    "senderIban": "string",
    "senderBankName": "string",
    "receiverIban": "string",
    "receiverBankName": "string",
    "statusMessage": "string"
  }
}
```

Transfer between sub-account and main accounts

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Body Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
assetId | true | Long
uuid    | true | UUID | Created from client
amount    | true | BigDecimal
targetUserId    | true | Long | User Id you want to transfer
type    | true | **TransferType** | _WithdrawFromTarget_, _DepositToTarget_


### Required Scope

`Withdraw`: Authorized to withdraw

## Cancel fiat withdraw

```http
POST /users/{userId}/transactions/{transactionUuid}/cancel
```

Cancels withdraw order of the transaction uuid.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |
transactionUuid    | UUID of the transaction 

### Required Scope

`Withdraw`: Authorized to withdraw

# Iban Endpoint

## Get users ibans

> Request:

```http
GET /users/{userId}/ibans
```

> Response:

```json
[
  {
    "id": 0,
    "iban": "string",
    "bankName": "string",
    "userId": 0,
    "accountName": "string"
  }
]
```

Returns users ibans.

### Required Scope

`PublicApi`: Basic Scope


# Market Endpoints

## Get market info

> Request:

```http
GET /markets
```

> Response:

```json
[
  {
    "currentPrice": 0,
    "dailyVolume": 0,
    "dailyChange": 0,
    "baseAssetId": 0,
    "quoteAssetId": 0,
    "highestPrice": 0,
    "lowestPrice": 0,
    "dailyNominalChange": 0
  }
]
```

Returns market info for all pairs.

### Public Request

# Order Endpoints

## Get users orders

> Request: 

```http
GET /users/{userId}/orders?baseAssetId={baseAssetId}&quoteAssetId={quoteAssetId}&orderType={orderType}&orderStatus={orderStatus}&after={after}&before={before}&page={page}&size={size}&sort={sort}
```

> Response:

```json
[
  {
    "price": 0,
    "orderType": "Market",
    "operationDirection": "Sell",
    "quantity": 0,
    "orderStatus": "Active",
    "matchStatus": "None",
    "matches": [
      "3fa85f64-5717-4562-b3fc-2c963f66afa6"
    ],
    "executedQuantity": 0,
    "averageMatchPrice": 0,
    "userId": 0,
    "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "baseAssetId": 0,
    "quoteAssetId": 0,
    "orderTime": "2021-12-13T18:18:52.345Z",
    "stopPrice": 0,
    "id": 0
  }
]
```

Filter users orders with query parameters.


### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAssetId | false | Long |
quoteAssetId | false | Long |
orderType    | false | **OrderType** | _Market_, _Limit_, _StopLimit_, _FillOrKill_, _ImmediateOrCancel_, _Other_
orderStatus    | false | [**OrderStatus**] | _Active_, _Canceled_, _WaitingValidation_, _Completed_, _Other_
after    | false | Instant
before    | false | Instant
page    | false | Int
size    | false | Int
sort    | false | String


### Required Scope

`PublicApi`: Basic Scope

### [Order Types] (https://en.wikipedia.org/wiki/Order_(exchange)#Conditional_orders)



## Get users orders count

> Request:

```http
GET /users/{userId}/orders/count?baseAssetId={baseAssetId}&quoteAssetId={quoteAssetId}&orderType={orderType}&orderStatus={orderStatus}&after={after}&before={before}
```

> Response:

```json
{
  "count": 0
}
```

Number of users filtered orders with query parameters.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAssetId | false | Long |
quoteAssetId | false | Long |
orderType    | false | **OrderType** | _Market_, _Limit_, _StopLimit_, _FillOrKill_, _ImmediateOrCancel_, _Other_
orderStatus    | false | [**OrderStatus**] | _Active_, _Canceled_, _WaitingValidation_, _Completed_, _Other_
after    | false | Instant
before    | false | Instant

### Required Scope

`PublicApi`: Basic Scope

## Create order

> Request:

```http
PUT /users/{userId}/orders
```

```json
{
  "baseAssetId": 0,
  "quoteAssetId": 0,
  "orderType": "Market",
  "operationDirection": "Buy",
  "quantity": 0,
  "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "limit": 0,
  "stopLimit": 0
}
```

> Response:

```json
{
  "matchCount": 0,
  "quantity": 0,
  "executedQuantity": 0,
  "averageMatchPrice": 0
}
```

Creates a new order.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Body Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAssetId | false | Long | 
quoteAssetId | false | Long | 
orderType    | false | **OrderType** | _Market_, _Limit_, _StopLimit_, _FillOrKill_, _ImmediateOrCancel_, _Other_
operationDirection    | false | **OperationDirection** | _Sell_, _Buy_
quantity    | false | BigDecimal
uuid    | false | UUID
limit    | false | BigDecimal
stopLimit    | false | BigDecimal

### Required Scope

`Trade`: Authorized to give orders

## Get order detail by order UUID

> Request:

```http
GET /users/{userId}/orders/{uuid}
```

> Response:

```json
{
  "price": 0,
  "orderType": "Market",
  "operationDirection": "Sell",
  "quantity": 0,
  "orderStatus": "Active",
  "matchStatus": "None",
  "matches": [
    "3fa85f64-5717-4562-b3fc-2c963f66afa6"
  ],
  "executedQuantity": 0,
  "averageMatchPrice": 0,
  "userId": 0,
  "uuid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "baseAssetId": 0,
  "quoteAssetId": 0,
  "orderTime": "2021-12-13T18:47:13.576Z",
  "stopPrice": 0,
  "id": 0
}
```

Get users order detail by order UUID.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |
uuid    | Order UUID

### Required Scope

`PublicApi`: Basic Scope

## Cancel orders

> Request

```http
POST /users/{userId}/orders/cancel
```

```json
{
  "baseAssetId": 0,
  "quoteAssetId": 0,
  "operationDirection": "Buy",
  "priceBelow": 0,
  "priceAbove": 0
}
```

Cancel filtered orders with body parameters.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Body Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAssetId | false | Long |
quoteAssetId | false | Long |
operationDirection    | false | **OperationDirection** | _Sell_, _Buy_
priceBelow    | false | BigDecimal
priceAbove | false | BigDecimal

### Required Scope

`Trade`: Authorized to give orders

## Cancel order

> Request

```http
POST /users/{userId}/orders/{uuid}/cancel
```

Update order status as Canceled and delete it from orderbook

### URL Parameters

Parameter | Description
--------- | -----------
userId    |
uuid    | Order UUID

### Required Scope

`Trade`: Authorized to give orders

## Get scaled order data

> Request

```http
GET /orders/group?baseAssetId={baseAssetId}&quoteAssetId={quoteAssetId}&scale={scale}
```

> Response: 

```json
{
  "timestamp": "2021-12-13T19:12:49.957Z",
  "version": 0,
  "sell": {
    "additionalProp1": 0,
    "additionalProp2": 0,
    "additionalProp3": 0
  },
  "buy": {
    "additionalProp1": 0,
    "additionalProp2": 0,
    "additionalProp3": 0
  }
}
```

Filter scaled order data

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAssetId | true | Long
quoteAssetId | true | Long
scale | true | int

### Public Request

# Restriction Endpoints

##Get user restriction

> Request

```http
GET /users/{userId}/restrictions
```

> Response:

```json
{
  "dailyTotal": 0,
  "dailyRemaining": 0,
  "monthlyTotal": 0,
  "monthlyRemaining": 0
}
```

Get users daily, monthly restrictions.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Query Parameters

Parameter | Description
--------- | -----------
type      | Withdraw or Deposit
assetId   |

### Required Scope

`PublicApi`: Basic Scope

# Socket Endpoints

## Create socket key

> Request

```http
POST /users/{userId}/socket/keys
```

> Response:

```json
{
  "key": "string"
}
```

Creates a key for connecting to the socket. With this key, the user listens for specific data.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Required Scope

`PublicApi`: Basic Scope

## Delete socket key

> Request:

```http
DELETE /users/{userId}/socket/keys
```

Deletes the socket key.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Required Scope

`PublicApi`: Basic Scope

# Trading Pair Endpoints

## Get trading pairs

> Request:

```http
GET /trading-pairs
```

> Response:

```json
[
  {
    "id": 0,
    "baseAssetId": 0,
    "quoteAssetId": 0,
    "symbol": "string",
    "status": "Trading",
    "maxNumOrders": 0,
    "minPrice": 0,
    "maxPrice": 0,
    "tickScale": 0,
    "productScale": 0,
    "multiplierUp": 0,
    "multiplierDown": 0,
    "averagePriceCount": 0,
    "minQuantity": 0,
    "maxQuantity": 0,
    "stepScale": 0,
    "minNotional": 0,
    "applyToMarket": true,
    "marketMinQuantity": 0,
    "marketMaxQuantity": 0,
    "marketStepSize": 0,
    "makerFeePercentageValue": 0,
    "takerFeePercentageValue": 0,
    "marketEnabled": true,
    "limitEnabled": true,
    "stopEnabled": true
  }
]
```

Retrieve all trading pair details.

### Public Request

## Get trading pair detail

> Request:

```http
GET /trading-pairs/base-asset/{baseAssetId}/quote-asset/{quoteAssetId}
```

> Response:

```json
{
  "id": 0,
  "baseAssetId": 0,
  "quoteAssetId": 0,
  "symbol": "string",
  "status": "Trading",
  "maxNumOrders": 0,
  "minPrice": 0,
  "maxPrice": 0,
  "tickScale": 0,
  "productScale": 0,
  "multiplierUp": 0,
  "multiplierDown": 0,
  "averagePriceCount": 0,
  "minQuantity": 0,
  "maxQuantity": 0,
  "stepScale": 0,
  "minNotional": 0,
  "applyToMarket": true,
  "marketMinQuantity": 0,
  "marketMaxQuantity": 0,
  "marketStepSize": 0,
  "makerFeePercentageValue": 0,
  "takerFeePercentageValue": 0,
  "marketEnabled": true,
  "limitEnabled": true,
  "stopEnabled": true
}
```

Retrieve trading pair detail by asset ids

### URL Parameters

Parameter | Description
--------- | -----------
baseAssetId    | 
quoteAssetId   |

### Public Request

# Transaction Endpoints

## Get transactions

> Request:

```http
GET /transactions?baseAssetId={baseAssetId}&quoteAssetId={quoteAssetId}&page={page}&size={size}&sort={sort}
```

> Response:

```json
{
  "transactions": [
    {
      "transactionDate": "2021-12-13T19:52:16.289Z",
      "matchedQuantity": 0,
      "matchedPrice": 0,
      "buyerTaker": true
    }
  ]
}
```

Filter transactions with query parameters.

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAssetId | false | Long
quoteAssetId | false | Long
page | false | Int            | Page number
size    | false | Int         | Number of data per page
sort    | false | String      | Variable to sort,sorting type(e.g. `id,asc`)

### Public Request

## Get users transactions

> Request:

```http
GET /users/{userId}/transactions?baseAssetId={baseAssetId}&quoteAssetId={quoteAssetId}&operationDirection={operationDirection}&orderUUID={orderUUID}&after={after}&before={before}&page={page}&size={size}&sort={sort}
```

> Response:

```json
{
  "transactions": [
    {
      "baseAssetId": 0,
      "quoteAssetId": 0,
      "orderUUID": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "transactionDate": "2021-12-13T19:43:07.730Z",
      "matchedQuantity": 0,
      "matchedPrice": 0,
      "userId": 0,
      "orderType": "string",
      "feeAmount": 0,
      "buyer": true
    }
  ]
}
```

Filter users transactions with query parameters.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAssetId | false | Long
quoteAssetId | false | Long
operationDirection    | false | **OperationDirection** | _Sell_, _Buy_
orderUUID    | false | UUID
after    | false | Instant
before    | false | Instant
page | false | Int            | Page number
size    | false | Int         | Number of data per page
sort    | false | String      | Variable to sort,sorting type(e.g. `id,asc`)


### Required Scope

`PublicApi`: Basic Scope

## Get users transactions count

> Request:

```http
GET /users/{userId}/transactions/count?baseAssetId={baseAssetId}&quoteAssetId={quoteAssetId}&operationDirection={operationDirection}&orderUUID={orderUUID}&after={after}&before={before}
```

> Response

```json
{
  "count": 0
}
```

Number of users filtered transactions with query parameters.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
baseAssetId | false | Long
quoteAssetId | false | Long
operationDirection    | false | **OperationDirection** | _Sell_, _Buy_
orderUUID    | false | UUID
after    | false | Instant
before    | false | Instant

### Required Scope

`PublicApi`: Basic Scope

## Get users daily total positions

> Request:

```http
GET /users/{userId}/daily/total-balance?after={after}&before={before}
```

> Response:

```json
[
  {
    "totalAmountTry": 0,
    "totalAmountUsd": 0,
    "date": 0
  }
]
```

Filter users daily total positions with query parameters. Returns the data showing the balance field on the dashboard.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
after    | false | Instant
before    | false | Instant

### Required Scope

`PublicApi`: Basic Scope

## Get users daily positions

> Request:

```http
GET /users/{userId}/daily/balance?after={after}&before={before}
```

> Response:

```json
[
  {
    "assets": {
      "additionalProp1": {
        "amount": 0,
        "amountTry": 0,
        "amountUsd": 0
      },
      "additionalProp2": {
        "amount": 0,
        "amountTry": 0,
        "amountUsd": 0
      },
      "additionalProp3": {
        "amount": 0,
        "amountTry": 0,
        "amountUsd": 0
      }
    },
    "date": 0
  }
]
```

Filter users daily positions with query parameters. Returns data showing daily balance graph.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Query Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
after    | false | Instant
before    | false | Instant

### Required Scope

`PublicApi`: Basic Scope

# Wallet Endpoints

## Get or Create address for wallet

> Request:

```http
GET /users/{userId}/wallets/{walletId}/network/{network}/address
```

> Response:

```json
{
  "walletId": 0,
  "assetId": 0,
  "asset": "string",
  "address": "string"
}
```

Get cryptocurrency address for wallet with the selected network. If not exists, create address for wallet with the selected network.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |
walletId  |
network   | **Available Networks**

- **Available Networks**: Available networks can be retrieved from [Get network configuration endpoint](https://docs.bitronit.com/#get-network-configuration)

### Required Scope

`PublicApi`: Basic Scope

## Get position by asset id

> Request:

```http
GET /users/{userId}/assets/{assetId}/wallet/position
```

> Response:

```json
{
  "amount": 0,
  "currentReservedAmount": 0,
  "availableAmount": 0
}
```

Get position of user by asset id.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |
assetId   |

### Required Scope

`PublicApi`: Basic Scope


## Get wallets

> Request:

```http
GET /users/{userId}/wallets
```

> Response:

```json
{
  "wallets": [
    {
      "walletId": 0,
      "userId": 0,
      "assetId": 0,
      "asset": "string",
      "positionDetail": {
        "positionId": 0,
        "totalAmount": 0,
        "reservedAmount": 0,
        "availableAmount": 0
      }
    }
  ]
}
```

Get wallets of user.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

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
[baseAsset, baseAssetId, quoteAsset, quoteAssetId, timestamp, scale, buy, sell, checksum]
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

**Keyed** channels are used with the key that is retrieved from POST /users/{userId}/socket/keys endpoint.

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
[baseAssetId, buyer, feeAmount, matchedPrice, matchedQuantity, orderType, orderUUID, quoteAssetId, transactionDate, userId]
```

> "keyed-external-transaction-update" Channel Data Model:

```js
ex: ['0x9e8…', 0.0004, 'ETH', 2, '2021-11-24T17:49:58.084900Z', 0, 0, false, 11893460, 'ETH', null, null, null, null, 'Success', '2021-11-24T17:49:58.084899Z', null, '6b3c9a80-7…', 'Withdraw',  1.6858248, 11704]
[address, amount, asset, assetId, completeDate, confirmedBlockCount, fee, fiat, id, network, receiverBankName, status, receiverIban, senderBankName, senderIban, statusUpdateDate ,transactionHash, transactionUUID, type, typicalPrice, userId]
```

> "keyed-order-create" Channel Data Model:

```js
ex: [null, 2, 0, 59191684, 1988.84447184, 'Buy', 'Market', null, 0.00405, 7, null, 14183, null, 'dbfded9c-d...']
[activated, baseAssetId, executedQuantity, id, maxVolume, operationDirection, orderType, price, quantity, quoteAssetId, stopPrice, userId, userType, uuid]
```

> "keyed-order-update" Channel Data Model:

```js
ex: ['Market', 'a85c0a90-1...', 14183, 'Completed', 0.00501, 44140.74316766]
[orderType, uuid, userId, status, executedQuantity, averageMatchPrice]
```

> "trade" Channel Data Model:

```js
ex: ['ETH', 2, null, false, 'e9f3b404-6', 44145.291, 0.00211, 'TRY', 7, "2022-01-09T11:30:25.896044Z"]
[baseAsset, baseAssetId, id, isBuyerTaker, matchId, matchedPrice, matchedQuantity, quoteAsset, quoteAssetId, time]
```

> "all-ticker" Channel Data Model:

```js
ex: [ 'LINK', 'TRY', 357.94, 363.54, 323.39, 103109.12208, 5.91, 19.96 ]
[baseAsset, quoteAsset, currentPrice, highestPrice, lowestPrice, dailyVolume, dailyChange, dailyNominalChange]
```

# Errors

[Error codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

## Client Errors

| HTTP Status Code | Error Code                         | Error Message                                              | Reason and Actions to fix
|------------------|-------------------------|-----------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 400              |                         | Not valid limit size: {$limit}, it should be in [1, 500]              | This error message is thrown when limit is bigger than 500 while getting candlesticks. In order to fix, limit should be in 1, 500 range. Please check your limits for a valid request.                                                                                                  |
| 401              | SIGNATURE UNAUTHORIZED  | Signature: {$signature} is not valid.                                 | This error message is thrown when the signature that is retrieved from the “Signature” header is not true. Please take a look at the [authentication section](https://docs.bitronit.com/#authentication) of the api documentation for the correct way to utilize Bitronit public api.   |
| 401              | SIGNATURE NOT_FOUND     | Signature not found in the request headers                            | This error message is thrown when the signature is not found in the request headers. Please take a look at the [authentication section](https://docs.bitronit.com/#authentication) of the api documentation for the correct way to utilize Bitronit public api.                         |
| 401              | API_KEY_NOT_FOUND       | Api-key not found.                                                    | This error message is thrown when the API Key is not found in the request headers. Please take a look at the section [authentication section](https://docs.bitronit.com/#authentication) of the api documentation for the correct way to utilize Bitronit public api.                   |
| 401              | IP_ADDRESS NOT_ALLOWED  | IP address $ipAddress is restricted.                                  | This error message is thrown when the request is sent from an IP address that is not added to IP whitelist. Please take a look at the [limits section](https://docs.bitronit.com/#limits) of the api documentation for the correct way to utilize Bitronit public api.                  |
| 401              | API_KEY NOT_ENABLED     | Api-key with id: $id is not enabled.                                  | This error message is thrown when API Keys status is disabled or expired. Please check the validity of your API Key.                                                                                                                                                                    |
| 404              | ADDRESS NOT_FOUND       | Address: {$address} not found in whitelist.                           | This error message is thrown while initiating crypto withdraw. If target address is not in whitelist, exception is thrown. Please add address to your whitelist in order to withdraw to the target account.                                                                             |
| 404              | USER_NOT_FOUND          | User with userId = ${userId} not found                                | This error message is thrown if a user with userId is not found. Check your userId in order to proceed with your request.                                                                                                                                                               |
| 404              | ASSET_NOT_FOUND         | Asset not found.                                                      | This error message is thrown when getting an asset with the wrong ticker. Please check the tickers name in your request.                                                                                                                                                                |
| 400              | WITHDRAW_IS NOT_ALLOWED FOR_ASSET| Withdraw is not allowed for asset: $assetId                  | This error message is thrown while initiating withdraw with a network that is not supported in Bitronit. Please check asset and network in order to proceed with your request.                                                                                                          |
| 400              | WITHDRAW_AMOUNT PRECISION_ERROR  | Amount scale: $scale exceeded allowed ${precision} for the ${ticker}| This error message is thrown while initiating withdraw, amount scale exceeds allowed precision. Please check amount and precision to proceed with your transaction.                                                                                                                     |
| 404              | NETWORK_CONFIG NOT_FOUND| Network $network for asset $asset not found. Fiat: $fiat              | This error message is thrown while initiating withdraw. assetId is not supported with the network config. Please check assets network support in Bitronit to find available networks for your withdraw transaction.                                                                     |
| 403              | WITHDRAW_IS NOT_ALLOWED FOR_USER | Withdraw is not allowed for userId: $userId.                 | This error message is thrown while initiating withdraw with a sub user. Please try again with parent account.                                                                                                                                                                           |
| 403              | TRANSFER_IS NOT_ALLOWED FOR_USER | Transfer is not allowed for userId: $userI                   | This error message is thrown while trying to transfer between main user and sub user, if the target account is not configured as a sub user. Please enable sub-user type for the target user.                                                                                           |
| 403              | TRANSFER_NOT ALLOWED    | Transfer only allowed between main user and its sub users             | This error message is thrown while trying to transfer with an account not marked as sub user. Transfers are only allowed between main user and its sub users.                                                                                                                           |
| 400              | ALREADY CANCELED        | Order was already canceled                                            | This error message is thrown while trying to cancel an order that was already cancelled.                                                                                                                                                                                                |
| 400              | ALREADY COMPLETED       | Order was already matched                                             | This error message is thrown while trying to cancel an order that was already matched.                                                                                                                                                                                                  |
| 404              |                         | Version not found (baseAssetId,quoteAssetId,scale)                    | This error message is thrown while trying to retrieve order group data with wrong parameters. Please control baseAssetId, quoteAssetId and scale parameters.                                                                                                                            |  
| 404              | PAIR_NOT_FOUND          | Trading pair not found.                                               | This error is thrown while trying to retrieve trading pair by wrong assetId. Please check assetIds in your request.                                                                                                                                                                     |
| 404              | WALLET_NOT_FOUND        | Wallet not found                                                      | This error is thrown when wallet is not found. Please check walletId in your request.                                                                                                                                                                                                   |
