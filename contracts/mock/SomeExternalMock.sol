pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

interface Fabric {
    function produce() external returns(Stats);
}
interface Stats {
    function updateStat(bytes32 tag) external;
    function record(bytes32 tag, uint256 value) external;
    function avgByTag(uint256 period, bytes32 tag) external view returns(uint256 avgValue);
    function avgSumByAllTags(uint256 period) external view returns(uint256 avgValue);
}

contract SomeExternalMock {
     
    Fabric fabricAddress;
    Stats private statsAddr;
    constructor(Fabric addr) public {
        fabricAddress = addr;
        
        statsAddr = fabricAddress.produce();
    }
    
    function getExtraStat() public returns(Stats) {
        return fabricAddress.produce();
    }
    
    function getStatsAddr() public view returns(Stats) {
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