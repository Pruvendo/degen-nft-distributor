pragma ton-solidity ^0.44.0;

import "Token.sol";
import "modifiers/PublicKeyValidator.sol";
import "interfaces/ITokenPublicKey.sol";

/**
 * ███╗   ██╗███████╗████████╗
 * ████╗  ██║██╔════╝╚══██╔══╝
 * ██╔██╗ ██║█████╗     ██║
 * ██║╚██╗██║██╔══╝     ██║
 * ██║ ╚████║██║        ██║
 * ╚═╝  ╚═══╝╚═╝        ╚═╝
 * Non-fungible token
 *
 * Error codes
 *     100 - Method for the owner only
 *     101 - Method for the manager only
 *     102 - Method for the owner or manager only
 *     103 - Method for the root only
 *     104 - Manager unlocked
 *     105 - Manager locked
 *     106 - Invalid lock time
 *
 *     200 - Public key can't be null
 *     201 - Address can't be null
 */
abstract contract TokenPublicKey is Token, PublicKeyValidator, ITokenPublicKey {
    /*************
     * VARIABLES *
     *************/
    uint256 private _owner;



    /*************
     * MODIFIERS *
     *************/
    modifier canChangeOwner() {
        _canChangeOwner();
        _;
    }



    /***************
     * CONSTRUCTOR *
     ***************/
    /**
     * owner ............... Public key of token owner.
     * manager ............. Contract that governs this contract.
     *                       If you don't want to set the manager, use 0:0000111122223333...
     * managerUnlockTime ... UNIX time. Time when the manager can be unlocked.
     *                       If you don't want to set the manager, use 0.
     */
    constructor(uint256 owner, address manager, uint32 managerUnlockTime)
        public
        publicKeyIsNotNull(owner)
        Token(manager, managerUnlockTime)
    {
        _owner = owner;
    }



    /*******************************************************
     * EXTERNAL * ONLY OWNER IF UNLOCKED OR LOCKED MANAGER *
     *******************************************************/
    /**
     * Owner or manager can change token owner.
     * owner ... Public key of token owner.
     */
    function changeOwner(uint256 owner)
        override
        external
        onlyUnlockedOwnerOrLockedManager
        publicKeyIsNotNull(owner)
        accept
    {
        uint256 previousOwner = _owner;
        _owner = owner;
        _onChangeOwner(previousOwner, owner);
    }



    /*************
     * RECEIVERS *
     *************/
    /**
     * Returns basic information about token.
     * root ............... Address of root contract.
     * id ................. Id of token.
     * publicKey .......... Public key of root contract. tvm.pubkey()
     * owner .............. Public key of token owner.
     * manager ............ Contract that governs this contract.
     * managerUnlockTime .. UNIX time. Time when manager can be unlocked.
     */
    function receiveInfo() override external view responsible returns(
            address root,
            uint128 id,
            uint256 publicKey,
            uint256 owner,
            address manager,
            uint32  managerUnlockTime
        )
    {
        return{value: 0, bounce: false, flag: 64} getInfo();
    }



    /***********
     * GETTERS *
     ***********/
    /**
     * Returns basic information about token.
     * root ............... Address of root contract.
     * id ................. Id of token.
     * publicKey .......... Public key of root contract. tvm.pubkey()
     * owner .............. Public key of token owner.
     * manager ............ Contract that governs this contract.
     * managerUnlockTime .. UNIX time. Time when the manager can be unlocked.
     */
    function getInfo() public view returns(
            address root,
            uint256 id,
            uint256 publicKey,
            uint256 owner,
            address manager,
            uint32  managerUnlockTime
        )
    {
        root = _root;
        id = _id;
        publicKey = tvm.pubkey();
        owner = _owner;
        manager = _manager;
        managerUnlockTime = _managerUnlockTime;
    }



    /************
     * INTERNAL *
     ************/
    /**
     * Returns true if contract called by owner.
     */
    function _onlyOwner() override internal view returns(bool) {
        return msg.pubkey() == _owner;
    }

    /**
     * Call after change of public key of token owner.
     * previousOwner ... Previous public key of token owner.
     * owner ........... New public key of token owner.
     */
    function _onChangeOwner(uint256 previousOwner, uint256 owner) virtual internal;

    /**
     * Revert() if owner or manager can't change owner address.
     */
    function _canChangeOwner() virtual internal;
}