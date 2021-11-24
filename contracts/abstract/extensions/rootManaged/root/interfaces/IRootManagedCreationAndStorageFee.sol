pragma ton-solidity ^0.44.0;

interface IRootManagedCreationAndStorageFee {
    /***************************
     * EXTERNAL * ONLY MANAGER *
     ***************************/
    /**
     * Manager can change values, which are needed to create a token.
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     * storageFee . Payment for create and store offer.
     */
    function setCreationFee(uint128 minValue, uint128 fee , uint128 storageFee) external;


    /*************
     * RECEIVERS *
     *************/
    /**
     * Returns values, which are needed to create a token.
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     * storageFee . Payment for create and store offer.
     */
    function receiveCreationFee() external view responsible returns(uint128 minValue, uint128 fee , uint128 storageFee);
}