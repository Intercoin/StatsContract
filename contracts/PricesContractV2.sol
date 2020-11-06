pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "./openzeppelin-contracts/contracts/math/SignedSafeMath.sol";
import "./openzeppelin-contracts/contracts/math/SafeMath.sol";
import "./openzeppelin-contracts/contracts/utils/EnumerableMap.sol";
//import "./openzeppelin-contracts/contracts/access/Ownable.sol";
import "./lib/StringUtils.sol";

contract PricesContractV2 {
    using SignedSafeMath for uint256;
    using SignedSafeMath for int256;
    using SafeMath for uint256;
    using StringUtils for string;
    
    uint256 constant sampleSize = 100;
    
    struct PriceStruct {
        
        uint256[sampleSize] data;
        
        uint256 total;
        uint256 average;
        uint256 median;
        
        bool overflow;
        uint256 index;
    }
    
    mapping(bytes32 => PriceStruct) prices;
    
    
    function record(
        string memory tag, 
        uint256 price
    ) 
        public 
    {
        
        bytes32 tagBytes32 = tag.stringToBytes32();
        uint256 index= prices[tagBytes32].index;
        
        if (index >= sampleSize) {
            index = 0;
            prices[tagBytes32].index = index;
            prices[tagBytes32].overflow = true;
        } else {
            prices[tagBytes32].index = prices[tagBytes32].index.add(1);
        }
        
        prices[tagBytes32].data[index] = price;
        
    }

    function viewData(string memory tag) public view returns(uint256 total,uint256 average, uint256 median) {
        bytes32 tagBytes32 = tag.stringToBytes32();
       
        total = 0;
        median = 0;
        average = 0;
        
        if (prices[tagBytes32].overflow == false && prices[tagBytes32].index == 0) {
            // left zeros
        } else if (prices[tagBytes32].overflow == false && prices[tagBytes32].index == 1) {
            total = prices[tagBytes32].data[0];
            median = prices[tagBytes32].data[0];
            average = prices[tagBytes32].data[0];
        } else {    
             
              
            uint256 len;
            if (prices[tagBytes32].overflow == false) {
                len = prices[tagBytes32].index; // pointer to next pos
            } else {
                len = sampleSize;
            }
       
            // fill in memory
            uint256[] memory data = new uint256[](len);
            for (uint256 i=0;i <= len-1;i++ ) {
                data[i]= prices[tagBytes32].data[i];
                total=total.add(data[i]);
            }
            
            average = total.div(data.length);
        
            data = sort(data);
            uint256 lenMiddle = (data.length).div(2);
            if (data.length % 2 == 0) {
                median = ((data[lenMiddle-1]).add(data[lenMiddle])).div(2);
            } else {
                median = data[lenMiddle];
            }
        }
        
    }
    
    
    function sort(uint256[] memory data) internal view returns(uint[] memory) {
       quickSort(data, int(0), int(data.length - 1));
       return data;
    }
    
    function quickSort(uint[] memory arr, int left, int right) internal view{
        int i = left;
        int j = right;
        if(i==j) return;
        uint pivot = arr[uint(left + (right - left) / 2)];
        while (i <= j) {
            while (arr[uint(i)] < pivot) i++;
            while (pivot < arr[uint(j)]) j--;
            if (i <= j) {
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }
    
}