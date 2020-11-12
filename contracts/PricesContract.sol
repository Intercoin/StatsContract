pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "./openzeppelin-contracts/contracts/math/SignedSafeMath.sol";
import "./openzeppelin-contracts/contracts/math/SafeMath.sol";
import "./openzeppelin-contracts/contracts/utils/EnumerableMap.sol";
import "./openzeppelin-contracts/contracts/access/Ownable.sol";
import "./lib/StringUtils.sol";

import "./ICommunity.sol";
import "./IPricesContract.sol";

contract PricesContract is Ownable, IPricesContract {
    
    int256 constant sampleSize = 10;
    int256 constant multiplier = 1e6;
    
    using SignedSafeMath for uint256;
    using SignedSafeMath for int256;
    using SafeMath for uint256;
    using StringUtils for string;
    
    struct PriceStruct {
        int256 count;
        int256 total;
        int256 average;
        int256 median;
        int256 variance;
        
        int256 prevPrice;
        
        bool alreadyInit;
    }
    
    ICommunity private communityAddress;
    string private communityRole;
    mapping(bytes32 => PriceStruct) prices;
    
    mapping(address => bytes32) vendorTags;
    
    modifier canRecord() {
        bool s = _canRecord();
        
        require(s == true, "Sender has not in accessible List");
        _;
    }
    
    constructor(
        ICommunity community,
        string memory roleName
    )
        public
    {
        communityAddress = community;
        communityRole = roleName;
    }
    
    /**
     * 
     */
    function recordByVendor(
        address vendor, 
        uint256 amount
    ) 
        external 
        override
        returns(bool s)
    {
        s = _canRecord();
        if (s == true) {
            bytes32 tag = vendorTags[vendor];
            if (tag == bytes32(0)) {
                // do nothing   tag does not found
                s = false;
            } else {
                _record(tag, int256(amount));
            }
            
        }
    }
    
    function addVendorTag(
        address vendor, 
        string memory tag
    ) 
        onlyOwner
        public 
    {
        vendorTags[vendor] = tag.stringToBytes32();
    }
    
    function removeVendorTag(
        address vendor
    ) 
        onlyOwner
        public 
    {
        vendorTags[vendor] = bytes32(0);
    }
    
    /**
     * @param tag tag name
     * @param price price
     */
    function record(
        string memory tag, 
        int256 price
    ) 
        public
        canRecord()
    {
        require(price>0, 'can not be negative'); 
        
        
        bytes32 tagBytes32 = tag.stringToBytes32();
      
        _record(tagBytes32, price);
        
        
        
    }
    
    /**
     * @param tag tag name
     */
    function viewData(string memory tag) public view returns(int256 total,int256 average, int256 median, int256 variance) {
        bytes32 tagBytes32 = tag.stringToBytes32();
        
        total = prices[tagBytes32].total.div(multiplier);
        average = prices[tagBytes32].average.div(multiplier);
        median = prices[tagBytes32].median.div(multiplier);
        variance = prices[tagBytes32].variance.div(multiplier);
        
    }
    
    /**
     * C interpretantion copysign fucntion
     * http://all-ht.ru/inf/prog/c/func/copysign,copysignf,copysignl.html
     */
    function copysign(int256 a, int256 b) internal returns(int256) {
        if (b>0) {
    		if (a<0) {
    			return -a;
    		}
    	} else {
    		if (a>0) {
    			return -a;
    		}
    	}
        return a;
    }
    
    function _canRecord() private returns(bool s){
        s = false;
        string[] memory roles = ICommunity(communityAddress).getRoles(msg.sender);
        for (uint256 i=0; i< roles.length; i++) {
            
            if (keccak256(abi.encodePacked(communityRole)) == keccak256(abi.encodePacked(roles[i]))) {
                s = true;
            }
        }
    }
    
    function _record(
        bytes32 tagBytes32, 
        int256 price
    ) 
        private 
    {
        price = price.mul(multiplier);
        
        prices[tagBytes32].total = prices[tagBytes32].total.add(price);
        
        if (prices[tagBytes32].alreadyInit == false) {
            prices[tagBytes32].alreadyInit = true;
            prices[tagBytes32].average = price;
            prices[tagBytes32].count = 1;
            prices[tagBytes32].median = price;
            prices[tagBytes32].prevPrice = price;
        } else {
            prices[tagBytes32].count = prices[tagBytes32].count.add(1);
            int256 oldAverage = prices[tagBytes32].average;
            
            // https://stackoverflow.com/questions/10930732/c-efficiently-calculating-a-running-median/15150143#15150143
            // for each sample
            // average += ( sample - average ) * 0.1f; // rough running average.
            // median += _copysign( average * 0.01, sample - median );
            // but "0.1f" replace to "sampleSize"
            prices[tagBytes32].average = prices[tagBytes32].average.add(
                (
                    (
                        (int256(price)).sub(prices[tagBytes32].average)
                    ).div(sampleSize)
                )
            );
            
            prices[tagBytes32].median = prices[tagBytes32].median.add(
                copysign( 
                    prices[tagBytes32].average.div(sampleSize.mul(sampleSize)), 
                    int256(price).sub(prices[tagBytes32].median)
                )
            );
            
            // calc variance
            // https://jonisalonen.com/2014/efficient-and-accurate-rolling-standard-deviation/
            // self.variance += (new-old)*(new-newavg+old-oldavg)/(self.N-1)
            prices[tagBytes32].variance = prices[tagBytes32].variance.add(
                (
                    (
                        price.sub(prices[tagBytes32].prevPrice)
                    ).mul(
                        price.sub(prices[tagBytes32].average)
                             .add(prices[tagBytes32].prevPrice)
                             .sub(oldAverage))
                ).div(
                    sampleSize.sub(int256(1))
                    )
                );
            
            prices[tagBytes32].prevPrice = price;
            
            
        }
    }
}