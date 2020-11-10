pragma solidity >=0.6.0 <0.7.0;

import "./openzeppelin-contracts/contracts/math/SignedSafeMath.sol";
import "./openzeppelin-contracts/contracts/math/SafeMath.sol";
import "./openzeppelin-contracts/contracts/utils/EnumerableMap.sol";
//import "./openzeppelin-contracts/contracts/access/Ownable.sol";
import "./lib/StringUtils.sol";

contract PricesContract {
    
    int256 constant sampleSize = 10;
    int256 constant multiplier = 1e6;
    
    using SignedSafeMath for uint256;
    using SignedSafeMath for int256;
    using SafeMath for uint256;
    using StringUtils for string;
    
    struct PriceStruct {
        
        int256 total;
        int256 average;
        int256 median;
        int256 variance;
        
        int256 prevPrice;
    }
    
    bool alreadyInit = false;
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
        
        price = price.mul(multiplier);
        
        bytes32 tagBytes32 = tag.stringToBytes32();
      
        prices[tagBytes32].total = prices[tagBytes32].total.add(price);
        
        /*
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
        */
        
        
        if (alreadyInit == false) {
            alreadyInit = true;
            prices[tagBytes32].average = price;
            prices[tagBytes32].median = price;
            prices[tagBytes32].prevPrice = price;
        } else {
            int256 oldAverage = prices[tagBytes32].average;
            
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
    
    /**
     * @param tag tag name
     */
    function viewData(string memory tag) public view returns(int256 total,int256 average, int256 median, int256 variance) {
        bytes32 tagBytes32 = tag.stringToBytes32();
        
        total = prices[tagBytes32].total.div(multiplier);
        average = prices[tagBytes32].average.div(multiplier);
        median = prices[tagBytes32].median.div(multiplier);
        variance = prices[tagBytes32].variance.div(multiplier).div(multiplier);
        
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