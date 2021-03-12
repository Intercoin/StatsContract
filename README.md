# StatsContract
Used to compute sums, counts and averages from incoming input across various categories and tags

# Deploy
when deploy it is not need to pass parameters in to constructor
But after need to run method init() because contract is upgradable

# Overview
once installed will be use methods:
<table>
<thead>
	<tr>
		<th>method name</th>
		<th>called by</th>
		<th>description</th>
	</tr>
</thead>
<tbody>
    <tr>
		<td><a href="#init">init</a></td>
		<td>anyone</td>
		<td>need to initialize after contract deploy</td>
	</tr>
	<tr>
		<td><a href="#updatestat">updateStat</a></td>
		<td>only which rolew specified at Community Contract</td>
		<td>actualize stats if want nothing to send</td>
	</tr>
    <tr>
		<td><a href="#record">record</a></td>
		<td>only which rolew specified at Community Contract</td>
		<td>Method reciev stats data</td>
	</tr>
	<tr>
		<td><a href="#avgbytag">avgByTag</a></td>
		<td>anyone</td>
		<td>return average by tag name and period</td>
	</tr>
	<tr>
		<td><a href="#avgsumbyalltags">avgSumByAllTags</a></td>
		<td>anyone</td>
		<td>return average by all tags name and period</td>
	</tr>
	<tr>
		<td><a href="#alltags">allTags</a></td>
		<td>anyone</td>
		<td>return list of all tags name</td>
	</tr>
</tbody>
</table>


## Methods

#### init

need to run after deploy

Params:
name  | type | description
--|--|--
community|address|address of community
roleName|string|role name which specified to send stats data

#### updateStat

actualize stats if want not nothing to send

Params:
name  | type | description
--|--|--
tag|bytes32|tag name

#### record

will send stats data 

Params:
name  | type | description
--|--|--
tag|bytes32|tag name
price|uint256|price

Note that all prices can be multiplied to some fraction to avoid zeros of integer type

#### avgByTag

will return average by tag name and period

Params:
name  | type | description
--|--|--
tag|string|tag name
period|uint256| period in seconds enum(86400,604800,2592000,31536000) ie STATS_DAY,STATS_WEEK,STATS_MONTH,STATS_YEAR

#### avgSumByAllTags 

will return average by all tags name

Params:
name  | type | description
--|--|--
period|uint256| period in seconds enum(86400,604800,2592000,31536000) ie STATS_DAY,STATS_WEEK,STATS_MONTH,STATS_YEAR

#### allTags 

will return list of all tags name

Return params:
name  | type | description
--|--|--
list|bytes32[]|list with tags name
