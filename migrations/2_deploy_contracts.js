var SpatialUnit = artifacts.require("./SpatialUnit.sol");
var SpatialUnitRegistry = artifacts.require("./SpatialUnitRegistry.sol");
var RightsRegistry = artifacts.require("./RightsRegistry.sol");
var RightsEnum = artifacts.require("./RightsEnum.sol");
var GovernRequest = artifacts.require("./zeppelin/GovernRequest.sol");
var MetadataRegistry = artifacts.require("./MetadataRegistry.sol");
var SafeMath = artifacts.require("./zeppelin/SafeMath.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(RightsEnum);
  deployer.deploy(MetadataRegistry);
  deployer.link(RightsEnum, RightsRegistry);
  deployer.deploy(RightsRegistry);

  deployer.deploy(SpatialUnit, accounts[0], 'test place', "u4u4dkkpdgg5");
  deployer.link(SpatialUnit, SpatialUnitRegistry);
  deployer.deploy(SpatialUnitRegistry);

  deployer.deploy(SafeMath);
  deployer.link(SpatialUnit, GovernRequest);
  deployer.link(RightsEnum, GovernRequest);
  deployer.link(RightsRegistry, GovernRequest);
  deployer.link(SafeMath, GovernRequest);
  deployer.deploy(GovernRequest, accounts[0], 'test req', 'test req', 10000, accounts[0]);
};
