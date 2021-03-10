pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "../interfaces/ICommunity.sol";
import "../interfaces/iStats.sol";

interface Factory {
    function produce(ICommunity community,string calldata roleName) external returns(iStats);
}


contract SomeExternalMock {
     
    Factory factoryAddress;
    iStats private statsAddr;
    constructor(
        Factory addr,
        ICommunity community,
        string memory roleName
    ) 
        public 
    {
        factoryAddress = addr;
        
        statsAddr = factoryAddress.produce(
            community,
            roleName
        );
    }
    
    function getExtraStat(
        ICommunity community,
        string memory roleName
    ) 
        public 
        returns(iStats) 
    {
        return factoryAddress.produce(
            community,
            roleName
        );
    }
    
    function getStatsAddr() public view returns(iStats) {
        return statsAddr;
    }
    function push1_10_values(bytes32 tag) public {
        statsAddr.record(tag, 1);
        statsAddr.record(tag, 2);
        statsAddr.record(tag, 3);
        statsAddr.record(tag, 4);
        statsAddr.record(tag, 5);
        statsAddr.record(tag, 6);
        statsAddr.record(tag, 7);
        statsAddr.record(tag, 8);
        statsAddr.record(tag, 9);
    }
    
    function avgByTag(uint256 period, bytes32 tag) public view returns(uint256 avgValue) {
        avgValue = statsAddr.avgByTag(period, tag);
    }
    function avgSumByAllTags(uint256 period) public view returns(uint256 avgValue) {
        avgValue = statsAddr.avgSumByAllTags(period);
    }

}