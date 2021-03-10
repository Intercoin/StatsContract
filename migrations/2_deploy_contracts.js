const Stats = artifacts.require("Stats");

module.exports = function(deployer) {
    deployer.deploy(Stats);
};