const BigNumber = require('bignumber.js');
const util = require('util');
const StatsMock = artifacts.require("StatsMock");
const StatsFactoryMock = artifacts.require("StatsFactoryMock");
const SomeExternalMock = artifacts.require("SomeExternalMock");
const SomeExternalMock2 = artifacts.require("SomeExternalMock2");
const CommunityMock = artifacts.require("CommunityMock");

const truffleAssert = require('truffle-assertions');
const helper = require("../helpers/truffleTestHelper");

contract('Stats', (accounts) => {
    
    // it("should assert true", async function(done) {
    //     await TestExample.deployed();
    //     assert.isTrue(true);
    //     done();
    //   });
    
    // Setup accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];  
    const accountThree = accounts[2];
    const accountFourth= accounts[3];
    const accountFive = accounts[4];
    const accountSix = accounts[5];
    const accountSeven = accounts[6];
    const accountEight = accounts[7];
    const accountNine = accounts[8];
    const accountTen = accounts[9];
    const accountEleven = accounts[10];
    const accountTwelwe = accounts[11];

    
    function randomIntFromInterval(min, max) { // min and max included
      return Math.floor(Math.random() * (max - min + 1) + min);
    }

    // setup useful values
    
    var PricesContractMockInstance;
    var multipleConst = 1e2;
    var tag1 = "0x3100000000000000000000000000000000000000000000000000000000000000";
    var tag2 = "0x3200000000000000000000000000000000000000000000000000000000000000";
    var tmp, tmp_total, tmp_count;
    var PERIOD_DAY = 86400;
    var PERIOD_WEEK = 604800;
    var PERIOD_MONTH = 2592000;
    var PERIOD_YEAR = 31536000;
    var membersRole = 'members';
    var membersRoleWrong = 'wrong-role';
    
    
    
    it('tests math', async () => {
        
        const CommunityMockInstance = await CommunityMock.new();
        var StatsInstance = await StatsMock.new({from: accountTen});
        await StatsInstance.init(CommunityMockInstance.address, membersRole, {from: accountTen});

        tmp_total=0; tmp_count=0;
        for(var i=1;i<10;i++) {
            tmp_total=tmp_total+i; 
            tmp_count++;
            await StatsInstance.record(tag1,i,{from: accountTen});
        }
        
        tmp = await StatsInstance.avgByTag(PERIOD_DAY, tag1, {from: accountTen});

        assert.equal(
            (BigNumber(tmp)).toString(10),
            (BigNumber(tmp_total).div(BigNumber(tmp_count))).toString(10),
            
            'Avg is not equal '
        );
        helper.advanceTimeAndBlock(PERIOD_DAY);
        helper.advanceTimeAndBlock(PERIOD_DAY);

        // make update 
        await StatsInstance.updateStat(tag1,{from: accountTen});

        tmp = await StatsInstance.avgByTag(PERIOD_WEEK, tag1, {from: accountTen});
        assert.equal(
            (BigNumber(tmp)).toString(10),
            (BigNumber(tmp_total).div(BigNumber(tmp_count))).toString(10),
            'Avg is not equal '
        );
        
        tmp = await StatsInstance.avgByTag(PERIOD_DAY, tag1, {from: accountTen});
        assert.equal(
            (BigNumber(tmp)).toString(10),
            (BigNumber(0)).toString(10),
            'Avg is not equal '
        );
        
        var tmp_total_day = tmp_total;
        var tmp_count_day = tmp_count;
        
        for(var i=1;i<10;i++) {
            tmp_total=tmp_total+i; 
            tmp_count++;
            await StatsInstance.record(tag1,i,{from: accountTen});
        }
        
        tmp = await StatsInstance.avgByTag(PERIOD_DAY, tag1, {from: accountTen});
        assert.equal(
            (BigNumber(tmp)).toString(10),
            (BigNumber(tmp_total_day).div(BigNumber(tmp_count_day))).toString(10),
            
            'Avg is not equal '
        );
        tmp = await StatsInstance.avgByTag(PERIOD_WEEK, tag1, {from: accountTen});
        assert.equal(
            (BigNumber(tmp)).toString(10),
            (BigNumber(tmp_total).div(BigNumber(tmp_count))).toString(10),
            'Avg is not equal '
        );
    }); 
    
    it('tests with factory', async () => {
        const CommunityMockInstance = await CommunityMock.new();
        // create factory
        var StatsFactoryMockInstance = await StatsFactoryMock.new({from: accountTen});
        
        //    CommunityMockInstance.address, membersRole,
        
        
        // create some external contract. imitation our CurrencyContract
        var SomeExternalMockInstance = await SomeExternalMock.new(StatsFactoryMockInstance.address, CommunityMockInstance.address, membersRole, {from: accountNine});
        
        // put through SomeExternalMock into Stats some values from 1 to 9
        await SomeExternalMockInstance.push1_10_values(tag1, {from: accountNine});
        
        var tmp = await SomeExternalMockInstance.avgByTag(PERIOD_DAY,tag1);
        assert.equal(
            (BigNumber(tmp)).toString(10),
            (BigNumber(5)).toString(10),
            'Avg is not equal '
        );

        // get address of Stats Contract and try to put statistic directly
        var statAddr = await SomeExternalMockInstance.getStatsAddr();
        

        // create some another external contract. imitation our CurrencyContract
        var SomeExternalMock2Instance = await SomeExternalMock2.new(statAddr, {from: accountEight});
        
       
        // but can be able get statistic
        var tmp = await SomeExternalMock2Instance.avgByTag(PERIOD_DAY,tag1);
        assert.equal(
            (BigNumber(tmp)).toString(10),
            (BigNumber(5)).toString(10),
            'Avg is not equal '
        );
        
    }); 
    
});
