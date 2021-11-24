pragma ton-solidity ^0.44.0;

interface IRootManaged {
    /***************************
     * EXTERNAL * ONLY MANAGER *
     ***************************/
    /**
     * Manager can change manager.
     * manager ... Contract that governs this contract.
     */
    function changeManager(address manager) external;



    /*************
     * RECEIVERS *
     *************/
    /**
     * Returns manager address.
     * manager ... Contract that governs this contract.
     */
    function receiveManager() external view responsible returns(address manager);
}