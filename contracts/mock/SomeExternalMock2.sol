pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

interface Stats {
    function updateStat(bytes32 tag) external;
    function record(bytes32 tag, uint256 value) external;
    function avgByTag(uint256 period, bytes32 tag) external view returns(uint256 avgValue);
    function avgSumByAllTags(uint256 period) external view returns(uint256 avgValue);
}

contract SomeExternalMock2 {
     
    
    Stats private statsAddr;
    constructor(Stats addr) public {
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