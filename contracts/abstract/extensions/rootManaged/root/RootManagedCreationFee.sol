pragma ton-solidity ^0.44.0;

import "./RootManaged.sol";
import "./interfaces/IRootManagedCreationFee.sol";

/**
 * Error codes
 *     1100 - Need more money
 */
abstract contract RootManagedCreationFee is RootManaged, IRootManagedCreationFee {
    /*************
     * VARIABLES *
     *************/
    uint128 internal _creationMinValue;
    uint128 internal _creationFee;



    /*************
     * MODIFIERS *
     *************/
    modifier creationPaymentIsEnough() {
        require(msg.value >= _creationMinValue, 1100, "Need more money");
        _;
    }



    /***************
     * CONSTRUCTOR *
     ***************/
    /**
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     */
    constructor(uint128 minValue, uint128 fee) public accept {
        _creationMinValue = minValue;
        _creationFee = fee;
    }



    /***************************
     * EXTERNAL * ONLY MANAGER *
     ***************************/
    /**
     * Manager can change values, which are needed to create a token.
     * Be careful to set the correct values, otherwise the contract will not work.
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     */
    function setCreationFee(uint128 minValue, uint128 fee) override external onlyManager accept {
        _creationMinValue = minValue;
        _creationFee = fee;
    }



    /*************
     * RECEIVERS *
     *************/
    /**
     * Returns values, which are needed to create a token.
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     */
    function receiveCreationFee() override external view responsible returns(uint128 minValue, uint128 fee) {
        return{value: 0, bounce: false, flag: 64} getCreationFee();
    }



    /***********
     * GETTERS *
     ***********/
    /**
     * Returns values, which are needed to create a token.
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     */
    function getCreationFee() public view returns(uint128 minValue, uint128 fee) {
        minValue = _creationMinValue;
        fee = _creationFee;
    }
}