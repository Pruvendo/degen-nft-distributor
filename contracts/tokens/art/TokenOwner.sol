pragma ton-solidity ^0.44.0;

import "ArtToken.sol";
import "ArtRoot.sol";

contract TokenOwner {

    constructor() public {
        require(msg.pubkey() != 0);
        require(tvm.pubkey() == msg.pubkey());
        tvm.accept();
    }



    /************
     * EXTERNAL *
     ************/

    function create(
        address root,
        uint128 value,
        uint[] uniqueVector
    )
        external
        pure
        acceptOwner
    {
        ArtRoot(root).create{
            value: value,
            callback: TokenOwner.onCreateToken
        }({
            owner: address(this),
            manager: address(1),
            managerUnlockTime: 4294967290,
            creator: address(1),
            creatorFees: 0,
            uniqueVector: uniqueVector
        });
    }

    address public __token;
    function onCreateToken(address token) public {
        __token = token;
    }

    function addHash(address token, uint256 hash) external pure acceptOwner {
        ArtToken(token).addHash(hash);
    }

    function changeOwner(address token, address owner) external pure acceptOwner {
        ArtToken(token).changeOwner(owner);
    }

    function getZero() public view returns (uint x) {
        x = 0;
    }

    /*************
     * MODIFIERS *
     *************/

    modifier acceptOwner() {
        require(msg.pubkey() == tvm.pubkey());
        tvm.accept();
        _;
    }
}