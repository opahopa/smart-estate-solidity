pragma solidity ^0.5.0;

contract RightsEnum {

    enum Rights {
        VIEWER,
        OWNER,
        TENANT,
        INVESTOR,
        GOVT,
        CARETAKER,
        ADMIN
    }
    Rights rights;

    constructor() public {
        rights = Rights.VIEWER;
    }

    function setValues(uint _value) public {
        require(uint(Rights.OWNER) >= _value);
        rights = Rights(_value);
    }

    function getValue() public view returns (uint){
        return uint(rights);
    }

}