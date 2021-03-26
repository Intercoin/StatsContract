// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

pragma experimental ABIEncoderV2;

import "../Stats.sol";


contract StatsMock is Stats {
     
     function getStats(uint256 period, bytes32 tag) public view returns (Data memory) {
         return stats[period][tag];
     }
     
     function get1(uint256 index) public view returns(Item memory) {
         return data[index];
     }
     function getNow(uint256 index) public view returns(uint256) {
         return block.timestamp;
     }
}