# StatsContract
Used to compute total, count and averages from incoming input across various categories and tags

# Deploy
when deploy it is need to pass parameters in to constructor

Params:
name  | type | description
--|--|--
community|address|address of community contract
roleName|string|community role of participants which allowance to put records

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

Note that all prices must be multiplied to some fraction to avoid zeros of integer type

#### viewData
return total/median/average/variance by tag name

Params:
name  | type | description
--|--|--
tag|string|tag name

#### addVendorTag 

Params:
name  | type | description
--|--|--
vendor|address| address of vendor
tag|string|tag name

#### removeVendorTag

Params:
name  | type | description
--|--|--
vendor|address| address of vendor
        
