pragma solidity ^0.5.0;


contract SpatialUnit
{
    address public owner;
    address public registry_address;
    address public receiver;
    string public name;
    string public geohash;
    address[] public ownerhistory;
    uint public ownertransfercount;

    mapping(address => uint) paymentpool;
    mapping(bytes32 => bytes32) keyvaluestore;

    constructor(address _owner, string memory _name, string memory _geohash)
    public
    payable
    {
        owner = _owner;
        ownerhistory.push(owner);
        registry_address = msg.sender;
        name = _name;
        geohash = _geohash;
    }

    function ()
    external
    payable
    {
        // fallback function
    }

    function getBalance()
    public
    view
    returns (uint)
    {
        return (address(this).balance);
    }

    function store(bytes32 _key, bytes32 _value)
    public
    {
        require(msg.sender == owner);
        keyvaluestore[_key] = _value;
    }

    function retrieve(bytes32 _key)
    public
    view
    returns (bytes32 _stored_val)
    {
        return (keyvaluestore[_key]);
    }

    function changeOwner(address _newOwner)
    public
    onlyOwner
    returns (address)
    {
        owner = _newOwner;
        ownerhistory.push(owner);
        ownertransfercount++;
        return (address(owner));
    }

    function execPayment(address _receiver, uint _amount)
    public
    payable
    onlyOwner
    {
        receiver = _receiver;
        require(_amount <= address(this).balance);
        paymentpool[receiver] += _amount;
    }

    function receivePayment()
    external
    {
        uint pmnt = paymentpool[msg.sender];
        paymentpool[msg.sender] = 0;
        msg.sender.transfer(pmnt);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}