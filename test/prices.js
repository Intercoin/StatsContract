const BN = require('bn.js'); // https://github.com/indutny/bn.js
const util = require('util');
const PricesContractMock = artifacts.require("PricesContractMock");
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
    
    // setup useful values
    
    var PricesContractMockInstance;
    var multipleConst = 1e6;
    
    it('tests single', async () => {
        var PricesContractMockInstance = await PricesContractMock.new();
        for(var i=1;i<10;i++) {
            await PricesContractMockInstance.record('test1', 100*multipleConst);
            await PricesContractMockInstance.record('test2', i*10*multipleConst);
            await PricesContractMockInstance.record('test3', i*multipleConst);
        }
        var viewData;
        
        viewData = await PricesContractMockInstance.viewData('test3');
        assert.equal(
            (1+2+3+4+5+6+7+8+9).toString(10),
            (viewData['total']/multipleConst).toString(10),
            'total is not equal '
        );
        assert.equal(
            (3.486783).toString(10),
            (viewData['average']/multipleConst).toString(10),
            'average is not equal '
        );
        assert.equal(
            (0.136187).toString(10),
            (viewData['median']/multipleConst).toString(10),
            'median is not equal '
        );
        
    }); 
    /*
    it('tests single', async () => {
        
        var PricesContractMockInstance = await PricesContractMock.new();
        
        for(var i=1;i<=10;i++) {
            await PricesContractMockInstance.record('test1', 100*multipleConst);
            await PricesContractMockInstance.record('test2', i*10*multipleConst);
            await PricesContractMockInstance.record('test3', i*multipleConst);
        }
        var viewData;
        
        viewData = await PricesContractMockInstance.viewData('test1');
        assert.equal(
            (10*100).toString(16),
            (viewData['total']/multipleConst).toString(16),
            'total is not equal '
        );
        assert.equal(
            (100).toString(16),
            (viewData['average']/multipleConst).toString(16),
            'average is not equal '
        );
        assert.equal(
            (100).toString(16),
            (viewData['median']/multipleConst).toString(16),
            'median is not equal '
        );
        // console.log('test.V=100;Times=10;Increment=0', '=============');
        // console.log('total', (viewData['total']/multipleConst).toString());
        // console.log('average', (viewData['average']/multipleConst).toString());
        // console.log('median', (viewData['median']/multipleConst).toString());
        
        viewData = await PricesContractMockInstance.viewData('test2');
        assert.equal(
            (10+20+30+40+50+60+70+80+90+100).toString(16),
            (viewData['total']/multipleConst).toString(16),
            'total is not equal '
        );
        assert.equal(
            (55).toString(16),
            (viewData['average']/multipleConst).toString(16),
            'average is not equal '
        );
        assert.equal(
            (55).toString(16),
            (viewData['median']/multipleConst).toString(16),
            'median is not equal '
        );
        // console.log('test.V=0;Times=10;Increment=10', '=============');
        // console.log('total', (viewData['total']/multipleConst).toString());
        // console.log('average', (viewData['average']/multipleConst).toString());
        // console.log('median', (viewData['median']/multipleConst).toString());
        
        viewData = await PricesContractMockInstance.viewData('test3');
        assert.equal(
            (1+2+3+4+5+6+7+8+9+10).toString(16),
            (viewData['total']/multipleConst).toString(16),
            'total is not equal '
        );
        assert.equal(
            (5.5).toString(16),
            (viewData['average']/multipleConst).toString(16),
            'average is not equal '
        );
        assert.equal(
            (5.5).toString(16),
            (viewData['median']/multipleConst).toString(16),
            'median is not equal '
        );
        // console.log('test.V=1;Times=10;Increment=1', '=============');
        // console.log('total', (viewData['total']/multipleConst).toString());
        // console.log('average', (viewData['average']/multipleConst).toString());
        // console.log('median', (viewData['median']/multipleConst).toString());
    });
    
    it('tests multiple', async () => {
        
        var PricesContractMockInstance = await PricesContractMock.new();
        
        var values1=[];
        var values2=[];
        var values3=[];
        for(var i=1;i<=10;i++) {
            values1.push(100*multipleConst);
            values2.push(i*10*multipleConst);
            values3.push(i*multipleConst);
            
        }
        await PricesContractMockInstance.records('test1', values1);
        await PricesContractMockInstance.records('test2', values2);
        await PricesContractMockInstance.records('test3', values3);
            
        var viewData;
        
        viewData = await PricesContractMockInstance.viewData('test1');
        assert.equal(
            (10*100).toString(16),
            (viewData['total']/multipleConst).toString(16),
            'total is not equal '
        );
        assert.equal(
            (100).toString(16),
            (viewData['average']/multipleConst).toString(16),
            'average is not equal '
        );
        assert.equal(
            (100).toString(16),
            (viewData['median']/multipleConst).toString(16),
            'median is not equal '
        );
        // console.log('test.V=100;Times=10;Increment=0', '=============');
        // console.log('total', (viewData['total']/multipleConst).toString());
        // console.log('average', (viewData['average']/multipleConst).toString());
        // console.log('median', (viewData['median']/multipleConst).toString());
        
        viewData = await PricesContractMockInstance.viewData('test2');
        assert.equal(
            (10+20+30+40+50+60+70+80+90+100).toString(16),
            (viewData['total']/multipleConst).toString(16),
            'total is not equal '
        );
        assert.equal(
            (55).toString(16),
            (viewData['average']/multipleConst).toString(16),
            'average is not equal '
        );
        assert.equal(
            (55).toString(16),
            (viewData['median']/multipleConst).toString(16),
            'median is not equal '
        );
        // console.log('test.V=0;Times=10;Increment=10', '=============');
        // console.log('total', (viewData['total']/multipleConst).toString());
        // console.log('average', (viewData['average']/multipleConst).toString());
        // console.log('median', (viewData['median']/multipleConst).toString());
        
        viewData = await PricesContractMockInstance.viewData('test3');
        assert.equal(
            (1+2+3+4+5+6+7+8+9+10).toString(16),
            (viewData['total']/multipleConst).toString(16),
            'total is not equal '
        );
        assert.equal(
            (5.5).toString(16),
            (viewData['average']/multipleConst).toString(16),
            'average is not equal '
        );
        assert.equal(
            (5.5).toString(16),
            (viewData['median']/multipleConst).toString(16),
            'median is not equal '
        );
        // console.log('test.V=1;Times=10;Increment=1', '=============');
        // console.log('total', (viewData['total']/multipleConst).toString());
        // console.log('average', (viewData['average']/multipleConst).toString());
        // console.log('median', (viewData['median']/multipleConst).toString());
    });
    
    it('tests 300', async () => {
        var times=30;
        var PricesContractMockInstance = await PricesContractMock.new();
        
        var values=[];
        
        var total = new BN(0, 10);
        var average = new BN(0, 10);
        var median = new BN(0, 10);
        var rnd;
        for(var i=1;i<=times;i++) {
            rnd = randomIntFromInterval(1,1000000);
            total=total.add(new BN(rnd, 10));
            values.push(rnd*multipleConst);
        }
        
        await PricesContractMockInstance.records('test1', values);
            
        var viewData;
        viewData = await PricesContractMockInstance.viewData('test1');
        
        
        assert.equal(
            (total).toString(10),
            (viewData['total']/multipleConst).toString(10),
            'total is not equal '
        );
        assert.equal(
            (parseFloat(
                (
                    total.mul(new BN(multipleConst,10)).div(new BN(times,10))
                ).toString(10)
            )/multipleConst),
            (viewData['average']/multipleConst).toString(10),
            'average is not equal '
        );

        var valuesSorted = values;
        valuesSorted.sort(function(a,b){ 
          return a-b;
        });

        median = (
                (new BN(valuesSorted[times/2-1],10)).add(new BN(valuesSorted[times/2],10))
            )
            .div(new BN(2,10));
            

        assert.equal(
            (parseFloat(median.toString(10))/multipleConst).toString(10),
            (viewData['median']/multipleConst).toString(10),
            'median is not equal '
        );
        
    });
    */
});
