# StatsContract
Used to compute average prices for transactions across various economic categories
# Deploy
when deploy it is not need to pass parameters in to constructor
But after need to run method init() because contract is upgradable

# Overview
once installed will be use methods:

## Methods

#### init
need to run after deploy

#### updateStat
actualize stats if want not nothing to send

Params:
name  | type | description
--|--|--
tag|bytes32|tag name

#### record
send stats data 
Params:
name  | type | description
--|--|--
tag|bytes32|tag name
price|uint256|price

Note that all prices can be multiplied to some fraction to avoid zeros of integer type

#### avgByTag
return average by tag name and period

Params:
name  | type | description
--|--|--
tag|string|tag name
period|uint256| period in seconds enum(86400,604800,2592000,31536000) ie STATS_DAY,STATS_WEEK,STATS_MONTH,STATS_YEAR

#### avgSumByAllTags 

Params:
name  | type | description
--|--|--
period|uint256| period in seconds enum(86400,604800,2592000,31536000) ie STATS_DAY,STATS_WEEK,STATS_MONTH,STATS_YEAR

        