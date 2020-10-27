# PricesContract
Used to compute total, average and median prices for transactions across various economic categories
# Deploy
when deploy it is not need to pass parameters in to constructor

# Overview
once installed will be use methods:

## Methods

#### record
put price with some tag 

Params:
name  | type | description
--|--|--
tag|string|tag name
price|int256|price

Note that all prices must be multiplied to some fraction to avoid zeros of uint type

#### viewData
return total/median/average/variance by tag name

Params:
name  | type | description
--|--|--
tag|string|tag name

