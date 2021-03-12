// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;

pragma experimental ABIEncoderV2;

import "../interfaces/iStats.sol";

contract SomeExternalMock2 {
     
    
    iStats private statsAddr;
    constructor(iStats addr) public {
        statsAddr = addr;
        
    }
    
    function push_some_values(bytes32 tag) public {
        statsAddr.record(tag, 1);
    }
    
    function avgByTag(uint256 period, bytes32 tag) public view returns(uint256 avgValue) {
        avgValue = statsAddr.avgByTag(period, tag);
    }
    function avgSumByAllTags(uint256 period) public view returns(uint256 avgValue) {
        avgValue = statsAddr.avgSumByAllTags(period);
    }

}