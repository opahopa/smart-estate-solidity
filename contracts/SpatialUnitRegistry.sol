pragma solidity ^0.5.0;

import "./SpatialUnit.sol";


contract SpatialUnitRegistry
{
    address public owner;
    // adding creator in addition to owner because ownership of a Spatial Unit can be transferred later
    uint public numSpUnits;
    mapping(address => Unit) records;
    address[] public keys;

    // events
    event SpatialUnitAdded(address indexed owner, string indexed _name, string indexed _geoHash);

    // structs
    struct Unit
    {
        address creator;
        string name;
        string geoHash;
        uint keysIndex;
    }

    constructor ()
    public
    {
        owner = msg.sender;
    }

    function addSpatialUnit(address _creator, string memory _name, string memory _geoHash)
    public
    returns (address _newSpatialunit, uint _keyslength)
    {
        SpatialUnit newSpatialUnit = new SpatialUnit(_creator, _name, _geoHash);
        // newSpatialUnit.changeOwner(msg.sender);
        address newSpatialUnitAddress = address(newSpatialUnit);

        keys.push(newSpatialUnitAddress);
        records[newSpatialUnitAddress].name = _name;
        records[newSpatialUnitAddress].geoHash = _geoHash;
        records[newSpatialUnitAddress].creator = _creator;
        records[newSpatialUnitAddress].keysIndex = keys.length;
        numSpUnits++;

        emit SpatialUnitAdded(_creator, _name, _geoHash);
        return (address(newSpatialUnit), keys.length);
    }

    function getSpatialUnit(address addr)
    public
    view
    returns (address creator, string memory name, string memory geoHash)
    {
        creator = records[addr].creator;
        name = records[addr].name;
        geoHash = records[addr].geoHash;
        return (creator, name, geoHash);
    }

}