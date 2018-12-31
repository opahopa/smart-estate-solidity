pragma solidity ^0.5.0;

import "./SpatialUnit.sol";
import "./RightsRegistry.sol";
import "./RightsEnum.sol";
import "./zeppelin/SafeMath.sol";


contract GovernRequest {
    using SafeMath for uint256;
    using SafeMath for uint16;

    SpatialUnit spatialUnit;
    RightsRegistry rightsRegistry;
    address owner;
    string name;
    string description;
    uint256 value;
    uint256 dateCreated;
    uint16 daysLimit;
    address payable recipient;
    bool complete;
    uint approveCount;
    uint rejectCount;
    mapping (address => bool) voters;

    constructor (
        address _owner,
        string memory _name,
        string memory _description,
        uint _value,
        address payable _recipient
    )
    public
    {
        owner = _owner;
        spatialUnit = SpatialUnit(msg.sender);

        //TODO: get address from oracle
        rightsRegistry = RightsRegistry(address(0xbA8dC1a692093d8aBD34e12aa05a4fE691121bB6));
        name = _name;
        description = _description;
        value = _value;
        recipient = _recipient;
        complete = false;
        approveCount = 0;
        dateCreated = block.timestamp;
        daysLimit = 7;
    }

    /**
     * Log a vote for a proposal
     *
     * @param _vote => vote for or against proposal
     *
     * Shouldn't use `for` in production. Need to re-think rights check.
     */
    function vote(bool _vote) public payable returns(bool) {

        // UnimplementedFeatureError: Nested arrays not yet implemented.
        // need to remodel the RightsRegistry.

        // bool isOwner = false;
        // RightsRegistry.Right[] memory rights = rightsRegistry.getRightsForTarget(msg.sender, address(spatialUnit));
        // for (uint16 i = 0; i < rights.length; i++) {
        //     if (rights[i].rightsType == RightsEnum.Rights.OWNER) {
        //         isOwner = true;
        //     }
        // }
        // require(isOwner);


        require(!voters[msg.sender]);

        voters[msg.sender] = true;
        if (_vote) {
            approveCount++;
        } else {
            rejectCount--;
        }
    }

    function finalizeRequest() public onlyOwner {
        require(!complete);
        require(approveCount > rejectCount);

        address(recipient).transfer(value);
        complete = true;
    }

    function isTimeFinished() private view returns(bool) {
        uint diff = block.timestamp.sub(daysLimit);
        if (diff > daysLimit.mul(7 days)) {
            return true;
        } else {
            return false;
        }
    }

    modifier onlyOwner()  {
        require(msg.sender == owner);
        _;
    }
}