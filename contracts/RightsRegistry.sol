pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "./RightsEnum.sol";


/*
/*    RightsRegistry managing the ownership rights for SpatialUnit.
/*    Heavily inspired by: https://github.com/ConsenSys/real-estate-standards
/*
/*    Implements addRight, deleteRight, transferRightForTarget.
/*
/*    All contracts been made within 24 hours => just showcase.
/*
*/
contract RightsRegistry {

    event RightsTransferred(address _from, address _to, address _target);

    struct Right
    {
        address holderEntity;
        address targetEntity;
        RightsEnum.Rights rightsType;
        address rightsContract;
        string infoUrl;
        uint index;
        uint status;
        uint32 startTime;
        uint32 expireTime;
    }

    address owner;
    Right[] rights;
    mapping(address => mapping(address => Right[])) indexedByHolderAndTarget;

    /*
        1st key: holder
        2nd key: target
        3rd key: Right
    */
    mapping(address => mapping(address => mapping(uint8 => bool))) rightsByHolderAndTarget;

    constructor() public {
        owner = msg.sender;
    }

    /// @dev Public for showcase purpose
    /// @param _target : SpatialUnit contract
    /// @param _holder : user address
    /// @param _rightsType : rigth types enum
    /// @param _startTime : right start time, suppose to be optional
    /// and have a default value as well as the endTime
    function addRight(
        address _target,
        address _holder,
        RightsEnum.Rights _rightsType,
        uint32 _startTime
    )
    public
    {
        // Check that the rightsType for targetEntity isn't already taken
        // add to `indexedByTargetAndHolder`

        uint len = rights.length;
        rights.length++;

        Right memory right;
        right.targetEntity = _target;
        right.holderEntity = _holder;
        right.rightsType   = _rightsType;

        if (_startTime == 0) {
            right.startTime = uint32(block.timestamp);
        } else {
            right.startTime = _startTime;
        }

        right.expireTime   = 30 days;
        right.index = len;

        rights[len] = right;

        uint olen = indexedByHolderAndTarget[_holder][_target].length;
        indexedByHolderAndTarget[_holder][_target].length++;
        indexedByHolderAndTarget[_holder][_target][olen] = rights[len];

        rightsByHolderAndTarget[_holder][_target][uint8(_rightsType)] = true;
    }

    function deleteRight(address _target, address _holder, RightsEnum.Rights _rightsType)
    private
    haveRight(_holder, _target, _rightsType)
    {
        rightsByHolderAndTarget[_holder][_target][uint8(_rightsType)] = false;
        for (uint i = 0; i < indexedByHolderAndTarget[_holder][_target].length; i++) {
            if (indexedByHolderAndTarget[_holder][_target][i].rightsType == _rightsType) {
                delete rights[indexedByHolderAndTarget[_holder][_target][i].index];
                delete indexedByHolderAndTarget[_holder][_target][i];
            }
        }
    }

    function getNumRights()
    public
    view
    returns (uint)
    {
        return rights.length;
    }

    /// @dev Get right by index in `rights` array.
    function getRightAt(uint rightIndex)
    public
    view
    returns
    (
        address holderEntity,
        address targetEntity,
        RightsEnum.Rights rightsType,
        address rightsContract,
        string memory infoUrl,
        uint status,
        uint startTime,
        uint expireTime
    )
    {
        holderEntity = rights[rightIndex].holderEntity;
        targetEntity = rights[rightIndex].targetEntity;
        rightsType = rights[rightIndex].rightsType;
        rightsContract = rights[rightIndex].rightsContract;
        infoUrl = rights[rightIndex].infoUrl;
        status = rights[rightIndex].status;
        startTime = rights[rightIndex].startTime;
        expireTime = rights[rightIndex].expireTime;
    }

    function getRightsForTarget(address _holder, address _target) public view returns (Right[] memory) {
        return indexedByHolderAndTarget[_holder][_target];
    }

    function transferRightForTarget(address _newHolder, address _target, RightsEnum.Rights _rightsType)
    public
    haveRight(msg.sender, _target, _rightsType)
    haveNoRight(_newHolder, _target, _rightsType)
    returns (bool)
    {
        addRight(_target, _newHolder, _rightsType, 0);
        deleteRight(_target, msg.sender, _rightsType);

        emit RightsTransferred(msg.sender, _newHolder, _target);
    }


    // Function Modifiers
    /// @dev Modifier for future functions
    modifier onlyOwnerRight(address _target) {
        require(rightsByHolderAndTarget[msg.sender][_target][uint8(RightsEnum.Rights.OWNER)] == true);
        _;
    }

    /// @dev Modifier for future functions
    modifier onlyOwner(address _target) {
        require(msg.sender == owner);
        _;
    }

    modifier haveRight(address _holder, address _target, RightsEnum.Rights _rightsType) {
        require(rightsByHolderAndTarget[_holder][_target][uint8(_rightsType)] == true);
        _;
    }
    modifier haveNoRight(address _holder, address _target, RightsEnum.Rights _rightsType) {
        require(rightsByHolderAndTarget[_holder][_target][uint8(_rightsType)] == false);
        _;
    }
}