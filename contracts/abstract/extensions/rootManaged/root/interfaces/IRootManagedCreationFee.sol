pragma ton-solidity ^0.44.0;

interface IRootManagedCreationFee {
    /***************************
     * EXTERNAL * ONLY MANAGER *
     ***************************/
    /**
     * Manager can change values, which are needed to create a token.
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     */
    function setCreationFee(uint128 minValue, uint128 fee) external;


    /*************
     * RECEIVERS *
     *************/
    /**
     * Returns values, which are needed to create a token.
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     */
    function receiveCreationFee() external view responsible returns(uint128 minValue, uint128 fee);
}