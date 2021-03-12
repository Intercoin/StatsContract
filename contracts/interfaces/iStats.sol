// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;

interface iStats {
    function updateStat(bytes32 tag) external;
    function record(bytes32 tag, uint256 value) external;
    function avgByTag(uint256 period, bytes32 tag) external view returns(uint256 avgValue);
    function avgSumByAllTags(uint256 period) external view returns(uint256 avgValue);
}