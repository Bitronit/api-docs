---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  

toc_footers:
  - <a href='https://bitronit.com/tr/'>Bitronit Exchange</a>

includes:
  - errors

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

Key       | Value
--------- | -----------
apiKey    | 966304e1-9be0-4d79-a1b0-95d069a7bfaf
secretKey | c0bad7a7eb95876bcd646bcf7f42e39ff1dd75311edb4f4df84de3e41f3b3c5d


> **HMAC SHA256 signature:**

```shell
$ echo -n "baseAssetId=5&quoteAssetId=6&scale=3" | openssl dgst -sha256 -hmac "c0bad7a7eb95876bcd646bcf7f42e39ff1dd75311edb4f4df84de3e41f3b3c5d"
    (stdin)= yDyq8EkvBoOm+GKKxch4TwD6K0L0q5KaTNLVQv8F0rg=
```
> **curl command:**

```shell
(HMAC SHA256)
$ curl -H "Authorization: Bearer 966304e1-9be0-4d79-a1b0-95d069a7bfaf" -H "Signature: yDyq8EkvBoOm+GKKxch4TwD6K0L0q5KaTNLVQv8F0rg=" -X GET 'https://api.bitronit.com/api/orders/group?baseAssetId=5&quoteAssetId=6&scale=3'

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
$ echo -n '{"priceBelow":12.5,"priceAbove":7.8,"operationDirection":"Buy","baseAssetId":3,"quoteAssetId":7}' | openssl dgst -sha256 -hmac "c0bad7a7eb95876bcd646bcf7f42e39ff1dd75311edb4f4df84de3e41f3b3c5d"
    (stdin)= xfxO7ec5WyzUleFLNjqFyUmsKOvLnTxYCvYXb7SNkfQ=
```
> **curl command:**

```shell
(HMAC SHA256)
$ curl -H "Authorization: Bearer 966304e1-9be0-4d79-a1b0-95d069a7bfaf" -H "Signature: xfxO7ec5WyzUleFLNjqFyUmsKOvLnTxYCvYXb7SNkfQ=" -X POST 'https://api.bitronit.com/api/users/5/orders/cancel' -d '{"priceBelow":12.5,"priceAbove":7.8,"operationDirection":"Buy","baseAssetId":3,"quoteAssetId":7}'

```


Parameter           | Value
---------           | -----
priceBelow          | 12.5
priceAbove          | 7.8
operationDirection  | Buy
baseAssetId         | 3
quoteAssetId        | 7

- requestBody:

{"priceBelow":12.5,"priceAbove":7.8,"operationDirection":"Buy","baseAssetId":3,
"quoteAssetId":7}


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

### Required Scope

`PublicApi`: Basic Scope

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

### Required Scope

`PublicApi`: Basic Scope

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

### Required Scope

`PublicApi`: Basic Scope

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

## Initiate withdraw

> Request:

```http
POST /users/{userId}/withdrawals
```
```json
{
  "assetId": 0,
  "amount": 0,
  "targetAddress": "string",
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

Initiate withdraw order from the given parameters. In crypto withdraws target address must be in whitelist.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |

### Body Parameters

Parameter | Required | Type   | Description
--------- | -------- | ------ | ------
assetId | true | Long |
amount    | true | BigDecimal |
targetAddress    | false | String | Address you want to withdraw
uuid    | true | UUID | Created from client
ibanId    | false | Long | IBAN you want to withdraw

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
GET /users/{userId}/orders/group?baseAssetId={baseAssetId}&quoteAssetId={quoteAssetId}&scale={scale}
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

### Required Scope

`PublicApi`: Basic Scope

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

### Required Scope

`PublicApi`: Basic Scope

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

### Required Scope

`PublicApi`: Basic Scope

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

## Create address for wallet

> Request:

```http
POST /users/{userId}/wallets/{walletId}/network/{network}/address
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

Create cryptocurrency address for wallet with the selected network.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |
walletId  |
network   | **Available Networks**

- **Available Networks**: BTC, LTC, ETH, BCH, TRON, AVAX

### Required Scope

`PublicApi`: Basic Scope

## Get wallet by asset id

> Request:

```http
GET /users/{userId}/assets/{assetId}/wallet
```

> Response:

```json
{
  "id": 0,
  "userId": 0,
  "asset": "string",
  "positionId": 0,
  "assetId": 0
}
```

Get wallet of user by asset id.

### URL Parameters

Parameter | Description
--------- | -----------
userId    |
assetId   |

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
