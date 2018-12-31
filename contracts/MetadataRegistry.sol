pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;


contract MetadataRegistry
{
    struct Link
    {
        string multiaddr;
        address owner;
    }

    Link[] numLinks;

    mapping(address => mapping(bytes32 => Link)) internal registry;
    mapping(address => bytes32[]) internal subjectKeys;
    mapping(address => mapping(bytes32 => uint)) internal subjectKeysIndex;

    event LinkSet
    (
        address indexed issuer,
        address indexed subject,
        bytes32 indexed key,
        Link value,
        uint updatedAt
    );

    event LinkRemoved
    (
        address indexed issuer,
        address indexed subject,
        bytes32 indexed key,
        uint removedAt
    );

    function setLink(address _subject, bytes32 _key, string memory _multiaddr)
    public
    {
        require(registry[_subject][_key].owner == address(0));
        Link memory newLink = Link(_multiaddr, msg.sender);
        registry[_subject][_key] = newLink;
        numLinks.length++;

        uint olen = subjectKeys[_subject].length;
        subjectKeys[_subject].length++;
        subjectKeys[_subject][olen] = _key;
        subjectKeysIndex[_subject][_key] = olen;

        emit LinkSet(msg.sender, _subject, _key, newLink, now);
    }

    function getLink(address _subject, bytes32 _key)
    public
    view
    returns (string memory multiaddr, address owner)
    {
        multiaddr = registry[_subject][_key].multiaddr;
        owner = registry[_subject][_key].owner;
    }

    function removeLink(address _subject, bytes32 _key)
    public
    {
        require(registry[_subject][_key].owner != address(0));
        require(msg.sender == registry[_subject][_key].owner);
        delete registry[_subject][_key];
        numLinks.length--;

        uint keyIndex = subjectKeysIndex[_subject][_key];

        // eliminate gap left in array
        for (uint i = keyIndex; i < subjectKeys[_subject].length-1; i++)
        {
            subjectKeys[_subject][i] = subjectKeys[_subject][i+1];
        }

        // removal of line below saves 5000 gas
        // delete subjectKeys[_subject][subjectKeys[_subject].length-1];
        subjectKeys[_subject].length--;

        delete subjectKeysIndex[_subject][_key];

        emit LinkRemoved(msg.sender, _subject, _key, now);
    }

    // return number of links attributed to a particular SpatialUnit
    function getNumLinks()
    public
    view
    returns (uint)
    {
        return numLinks.length;
    }
}