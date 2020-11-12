const BN = require('bn.js'); // https://github.com/indutny/bn.js
const util = require('util');
const PricesContractMock = artifacts.require("PricesContractMock");
const SomeExternalContractMock = artifacts.require("SomeExternalContractMock");

const CommunityMock = artifacts.require("CommunityMock");
const truffleAssert = require('truffle-assertions');
const helper = require("../helpers/truffleTestHelper");

contract('PricesContract', (accounts) => {
    
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
    function copysign(a, b) {
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
    // setup useful values
    
    var PricesContractMockInstance;
    var multipleConst = 1e2;
    
    it('tests single', async () => {
        
        var CommunityMockInstance = await CommunityMock.new({from: accountTen});
        
        var PricesContractMockInstance = await PricesContractMock.new(
            CommunityMockInstance.address, // ICommunity communityAddress,
            'members', // string memory communityRole,
            {from: accountTen});
            
            
        var alreadyInit = false;            
        let price1,average1,median1,prevPrice1,total1;
        
        sampleSize=10;
        for(var i=1;i<10;i++) {
            
            price1 = i*multipleConst;
            
            await PricesContractMockInstance.record('test1', price1);
            
            total1 = total1+price1;
            
            if (alreadyInit == false) {
                alreadyInit = true;
                average1 = price1;
                median1 = price1;
                total1 = price1;
                prevPrice1 = price1;
            } else {
                average1 = average1+((price1-average1)/sampleSize);
                
                median1 = median1 +(
                    copysign( 
                        average1/(sampleSize*sampleSize), 
                        (price1-median1)
                    )
                );
            }
            prevPrice1 = price1;
        }
        var viewData;

        viewData = await PricesContractMockInstance.viewData('test1');
        assert.equal(
            total1.toFixed(),
            (viewData['total']).toString(10),
            'total is not equal '
        );
        assert.equal(
            average1.toFixed(),
            (viewData['average']).toString(10),
            'average is not equal '
        );
        assert.equal(
            median1.toFixed(),
            (viewData['median']).toString(10),
            'median is not equal '
        );
        
    }); 
    
    it('add remove vendor tag', async () => {
        var CommunityMockInstance = await CommunityMock.new({from: accountTen});
        
        var PricesContractMockInstance = await PricesContractMock.new(
            CommunityMockInstance.address, // ICommunity communityAddress,
            'members', // string memory communityRole,
            {from: accountTen});
        
        await PricesContractMockInstance.addVendorTag(accountOne, 'tag1', {from: accountTen});
        await PricesContractMockInstance.removeVendorTag(accountOne, {from: accountTen});
        await PricesContractMockInstance.removeVendorTag(accountTwo, {from: accountTen});
    }); 
    
    it('test math via vendor tag', async () => {
        
        var CommunityMockInstance = await CommunityMock.new({from: accountTen});
        
        
        var PricesContractMockInstance = await PricesContractMock.new(
            CommunityMockInstance.address, // ICommunity communityAddress,
            'members', // string memory communityRole,
            {from: accountTen});
        
        var SomeExternalContractMockInstance = await SomeExternalContractMock.new(PricesContractMockInstance.address, {from: accountTen});
        
        await PricesContractMockInstance.addVendorTag(accountTwo, 'tag1', {from: accountTen});
        
        var alreadyInit = false;            
        let price1,average1,median1,prevPrice1,total1;
        sampleSize=10;
        for(var i=1;i<10;i++) {
            
            price1 = i*multipleConst;
            await SomeExternalContractMockInstance.record(accountTwo, price1);
            
            total1 = total1+price1;
            
            if (alreadyInit == false) {
                alreadyInit = true;
                average1 = price1;
                median1 = price1;
                total1 = price1;
                prevPrice1 = price1;
            } else {
                average1 = average1+((price1-average1)/sampleSize);
                
                median1 = median1 +(
                    copysign( 
                        average1/(sampleSize*sampleSize), 
                        (price1-median1)
                    )
                );
            }
            prevPrice1 = price1;
        }
        
        var viewData;

        viewData = await PricesContractMockInstance.viewData('tag1');
        assert.equal(
            total1.toFixed(),
            (viewData['total']).toString(10),
            'total is not equal '
        );
        assert.equal(
            average1.toFixed(),
            (viewData['average']).toString(10),
            'average is not equal '
        );
        assert.equal(
            median1.toFixed(),
            (viewData['median']).toString(10),
            'median is not equal '
        );
    }); 
    
});
