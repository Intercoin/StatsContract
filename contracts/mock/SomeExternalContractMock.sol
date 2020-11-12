pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "../IPricesContract.sol";

contract SomeExternalContractMock {
    IPricesContract addrContract;
    constructor(
        IPricesContract addr
    )
        public
    {
        addrContract = addr;
    }
    
    function record(
        address vendor, 
        uint256 price
    ) 
        public
    {
        addrContract.recordByVendor(vendor, price);
    }
}