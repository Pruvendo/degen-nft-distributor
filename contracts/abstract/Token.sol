pragma ton-solidity ^0.44.0;

import "modifiers/Accept.sol";
import "interfaces/IToken.sol";
import "./modifiers/AddressValidator.sol";

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
 *     201 - Address can't be null
 */
abstract contract Token is Accept, AddressValidator, IToken {
    /**********
     * STATIC *
     **********/
    address static _root;
    uint256 static _id;



    /*************
     * VARIABLES *
     *************/
    address internal _manager;
    uint32  internal _managerUnlockTime;



    /*************
     * MODIFIERS *
     *************/
    modifier onlyOwner() {
        require(_onlyOwner(), 100, "Method for the owner only");
        _;
    }

    modifier onlyManager {
        require(msg.sender == _manager, 101, "Method for the manager only");
        _;
    }

    modifier onlyUnlockedOwnerOrLockedManager {
        require(
            (_onlyOwner() && now >= _managerUnlockTime) ||
            (msg.sender == _manager && now < _managerUnlockTime),
            102,
            "Method for the owner or manager only"
        );
        _;
    }

    modifier onlyRoot() {
        require(msg.sender == _root, 103, "Method for the root only");
        _;
    }

    modifier locked() {
        require(now < _managerUnlockTime, 104, "Manager unlocked");
        _;
    }

    modifier unlocked() {
        require(now >= _managerUnlockTime, 105, "Manager locked");
        _;
    }

    modifier unlockTimeIsValid(uint32 unlockTime) {
        require(now < unlockTime, 106, "Invalid lock time");
        _;
    }



    /***************
     * CONSTRUCTOR *
     ***************/
    /**
     * manager ............. Contract that governs this contract.
     *                       If you don't want to set the manager, use 0:0000111122223333...
     * managerUnlockTime ... UNIX time. Time when the manager can be unlocked.
     *                       If you don't want to set the manager, use 0.
     */
    constructor(address manager, uint32 managerUnlockTime)
        public
        onlyRoot
        addressIsNotNull(manager)
        accept
    {
        _manager = manager;
        _managerUnlockTime = managerUnlockTime;
    }



    /*******************************************************
     * EXTERNAL * ONLY OWNER IF UNLOCKED OR LOCKED MANAGER *
     *******************************************************/
    /**
     * Owner can set manager and lock. To prevent manager from replacing during trading, he is locked.
     * If manager is already locked, call revert().
     * manager ...... Contract that governs this contract.
     * unlockTime ... UNIX time. Time when manager can be unlocked.
     */
    function lockManager(address manager, uint32 unlockTime)
        override
        external
        onlyUnlockedOwnerOrLockedManager
        addressIsNotNull(manager)
        unlockTimeIsValid(unlockTime)
        accept
    {
        _manager = manager;
        _managerUnlockTime = unlockTime;
    }

    /**
     * Owner can lock manager. To prevent manager from replacing during trading, he is locked.
     * If manager is already locked, call revert().
     * unlockTime ... UNIX time. Time when manager can be unlocked.
     */
    function lock(uint32 unlockTime)
        override
        external
        onlyUnlockedOwnerOrLockedManager
        unlockTimeIsValid(unlockTime)
        accept
    {
        _managerUnlockTime = unlockTime;
    }



    /**********************************
     * EXTERNAL * ONLY LOCKED MANAGER *
     **********************************/
    /**
     * Manager can unlock himself.
     * If manager is already unlocked, call revert().
     */
    function unlock() override external onlyManager accept {
        _managerUnlockTime = 0;
    }



    /************
     * INTERNAL *
     ************/
    /**
     * Returns true if contract called by owner.
     */
    function _onlyOwner() virtual internal view returns(bool);
}