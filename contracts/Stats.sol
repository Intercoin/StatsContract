// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.8.0;

pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "./interfaces/ICommunity.sol";

contract Stats is OwnableUpgradeable {
    using SafeMathUpgradeable for uint256;
    
    uint256[] internal periods;
    
   
    uint256 private tagsIndex;
    mapping (bytes32 => uint256) internal _tags;
    mapping (uint256 => bytes32) internal _tagsIndices;
    
    struct Item {
        uint256 value;
        uint256 timestamp;
        
    }
    struct Data {
        uint256 total;
        uint256 count;
        uint256 oldestKey;

    }
    
    uint256 dataIndex;
    mapping (uint256 => Item) data;
    
    //       period             tag
    mapping (uint256 => mapping(bytes32 => Data)) stats;

    ICommunity private communityAddress;
    string private communityRole;
    
    
    /**
     * @param community address of CommunityContract
     * @param roleName whitelist role name
     */
    function init(
        ICommunity community,
        string memory roleName
    ) 
        public 
        initializer 
    {
        __Ownable_init();
        
        communityAddress = community;
        communityRole = roleName;
        
        periods.push(86400);    // STATS_DAY    24*60*60
        periods.push(604800);   // STATS_WEEK   7*24*60*60
        periods.push(2592000);  // STATS_MONTH  30*24*60*60
        periods.push(31536000); // STATS_YEAR   365*24*60*60
        dataIndex = 1;
        tagsIndex = 1;
    }
    
    modifier canSendStats() {

        bool s = false;
        string[] memory roles = ICommunity(communityAddress).getRoles(msg.sender);
        for (uint256 i=0; i< roles.length; i++) {
            
            if (keccak256(abi.encodePacked(communityRole)) == keccak256(abi.encodePacked(roles[i]))) {
                s = true;
            }
        }
      
        require(s == true, "Sender is not in whitelist");
        
        _;
    }
    
    
    function updateStat(bytes32 tag) public canSendStats {

        createTag(tag);
        for(uint256 i=0; i<periods.length; i++) {
            updatePeriod(periods[i], tag);
        }
    }
    
    /**
     * @param tag tagname
     * @param value price,fraction etc
     */
    function record(bytes32 tag, uint256 value) public canSendStats {
        createTag(tag);
        
        data[dataIndex].value = value;
        data[dataIndex].timestamp = block.timestamp;
        
        for(uint256 i=0; i<periods.length; i++) {
            updatePeriod(periods[i], tag, value);
        }
        
        dataIndex=dataIndex.add(1);
    }

    /**
     * @param tag tagname
     * @param period period in seconds enum(86400,604800,2592000,31536000) ie STATS_DAY,STATS_WEEK,STATS_MONTH,STATS_YEAR
     */
    function avgByTag(uint256 period, bytes32 tag) public view returns(uint256 avgValue) {
        if (stats[period][tag].count>0) {
            avgValue = stats[period][tag].total.div(stats[period][tag].count);
        }
    }
    
    /**
     * @param period period in seconds enum(86400,604800,2592000,31536000) ie STATS_DAY,STATS_WEEK,STATS_MONTH,STATS_YEAR
     */
    function avgSumByAllTags(uint256 period) public view returns(uint256 avgValue) {
        for(uint256 i=1; i<tagsIndex; i++) {
            avgValue= avgValue.add(avgByTag(period,_tagsIndices[i]));
        }
    }
    
    function allTags() public view returns(bytes32[] memory) {
        bytes32[] memory ret = new bytes32[](tagsIndex-1);
        for(uint256 i=1; i<tagsIndex; i++) {
            ret[i-1]= _tagsIndices[i];
        }
        return ret;
    }
    /**
     * @param tag tagname
     * @param period period in seconds enum(86400,604800,2592000,31536000) ie STATS_DAY,STATS_WEEK,STATS_MONTH,STATS_YEAR
     */
    function updatePeriod(uint256 period, bytes32 tag) internal {
        if (stats[period][tag].oldestKey == 0) {
        } else {
            uint256 key;
            key = stats[period][tag].oldestKey;

            while (((block.timestamp.sub(data[key].timestamp)) > period) && (key < (dataIndex))) {

                stats[period][tag].total = stats[period][tag].total.sub(data[key].value);
                stats[period][tag].count = stats[period][tag].count.sub(1);
                
                key = key.add(1);
                stats[period][tag].oldestKey = key;
            }
        }
    }
    
    /**
     * @param tag tagname
     * @param period period in seconds enum(86400,604800,2592000,31536000) ie STATS_DAY,STATS_WEEK,STATS_MONTH,STATS_YEAR
     * @param value price,fraction etc
     */
    function updatePeriod(uint256 period, bytes32 tag, uint256 value) internal {
        
        updatePeriod(period, tag);
        
        if (stats[period][tag].oldestKey == 0) {
            stats[period][tag].oldestKey = dataIndex;
        }
        
        stats[period][tag].total = stats[period][tag].total.add(value);
        stats[period][tag].count = stats[period][tag].count.add(1);
    }
    
    /**
     * @param tag tagname
     */
    function createTag(bytes32 tag) private {
        if (_tags[tag] == 0) {
            _tags[tag] = tagsIndex;
            _tagsIndices[tagsIndex] = tag;
            tagsIndex = tagsIndex.add(1);
        }
       
    }
}