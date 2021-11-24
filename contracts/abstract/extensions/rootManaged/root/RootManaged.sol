pragma ton-solidity ^0.44.0;

import "./interfaces/IRootManaged.sol";
import "../../../Root.sol";

/**
 * Error codes
 *     1000 - Method for the manager only
 *     1001 - Manager address can't be null
 */
abstract contract RootManaged is Root, IRootManaged {
    /*************
     * VARIABLES *
     *************/
    address internal _manager;



    /*************
     * MODIFIERS *
     *************/
    modifier onlyManager {
        require(msg.sender == _manager, 1000, "Method for the manager only");
        _;
    }

    modifier managerIsNotNull(address manager) {
        require(manager.value != 0, 1001, "Manager address can't be null");
        _;
    }



    /***************
     * CONSTRUCTOR *
     ***************/
    /**
     * manager ... Contract that governs this contract.
     */
    constructor(address manager) public managerIsNotNull(manager) accept {
        _manager = manager;
    }



    /***************************
     * EXTERNAL * ONLY MANAGER *
     ***************************/
    /**
     * Manager can change manager.
     * manager ... Contract that governs this contract.
     */
    function changeManager(address manager) override external onlyManager managerIsNotNull(manager) accept {
        _manager = manager;
    }



    /*************
     * RECEIVERS *
     *************/
    /**
     * Returns manager address.
     * manager ... Contract that governs this contract.
     */
    function receiveManager() override external view responsible returns(address manager) {
        return{value: 0, bounce: false, flag: 64} getManager();
    }



    /***********
     * GETTERS *
     ***********/
    /**
     * Returns manager address.
     * manager ... Contract that governs this contract.
     */
    function getManager() public view returns(address manager) {
        manager = _manager;
    }
}