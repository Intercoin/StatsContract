pragma solidity >=0.6.0 <0.7.0;

import "./openzeppelin-contracts/contracts/math/SignedSafeMath.sol";
import "./openzeppelin-contracts/contracts/math/SafeMath.sol";
import "./openzeppelin-contracts/contracts/utils/EnumerableMap.sol";
//import "./openzeppelin-contracts/contracts/access/Ownable.sol";
import "./lib/StringUtils.sol";

contract PricesContract {
    
    using SignedSafeMath for uint256;
    using SignedSafeMath for int256;
    using SafeMath for uint256;
    using StringUtils for string;
    
    struct PriceStruct {
        
        int256 total;
        int256 average;
        int256 median;
        
    }
    
    mapping(bytes32 => PriceStruct) prices;
    
    /**
     * @param tag tag name
     * @param price price
     */
    function record(
        string memory tag, 
        int256 price
    ) 
        public 
    {
        
        bytes32 tagBytes32 = tag.stringToBytes32();
      
        prices[tagBytes32].total = prices[tagBytes32].total.add(price);
      
        // https://stackoverflow.com/questions/10930732/c-efficiently-calculating-a-running-median/15150143#15150143// for each sample
        // average += ( sample - average ) * 0.1f; // rough running average.
        // median += _copysign( average * 0.01, sample - median );
        prices[tagBytes32].average = prices[tagBytes32].average.add(
            (
                (int256(price)).sub(prices[tagBytes32].average)
            ).div(1e1)
        );
        prices[tagBytes32].median = prices[tagBytes32].median.add(
                copysign( 
                    prices[tagBytes32].average.div(1e2), 
                    int256(price).sub(prices[tagBytes32].median)
                )
            );
        
    }
    
    /**
     * @param tag tag name
     */
    function viewData(string memory tag) public view returns(int256 total,int256 average, int256 median) {
        bytes32 tagBytes32 = tag.stringToBytes32();
        
        total = prices[tagBytes32].total;
        average = prices[tagBytes32].average;
        median = prices[tagBytes32].median;
        
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

}