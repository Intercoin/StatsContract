pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "../PricesContract.sol";


contract PricesContractMock is PricesContract {
    constructor(
        ICommunity community,
        string memory roleName
        
    )
        public
        PricesContract(community,roleName)
    {
        
    }
    
    function records(
        string memory tag, 
        int256[] memory prices
    ) 
        public
    {
        for (uint256 i=0;i<prices.length;i++) {
            record(tag, prices[i]);
        }
    }
}