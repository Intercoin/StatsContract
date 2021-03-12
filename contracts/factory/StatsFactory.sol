// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;

import "../Stats.sol";

contract StatsFactory {
    
    Stats private implementationContract;
    event Produced(Stats addr);
    constructor () public {
        implementationContract = new Stats();
    }
  
    function produce(
        ICommunity community,
        string memory roleName
    ) 
        public 
        returns (Stats)
    {
    
        Stats proxy = Stats(
            createClone(address(implementationContract))
        );
        
        proxy.init(community, roleName);
        proxy.transferOwnership(msg.sender);
        emit Produced(proxy);
        return proxy;
    }
  
    function createClone(
        address target
    )
        internal 
        returns (address result) 
    {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            result := create(0, clone, 0x37)
        }
    }
  
}
