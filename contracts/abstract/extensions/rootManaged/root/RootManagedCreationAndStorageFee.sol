pragma ton-solidity ^0.44.0;

import "./RootManaged.sol";
import "./interfaces/IRootManagedCreationAndStorageFee.sol";

/**
 * Error codes
 *     1100 - Need more money
 *     1101 - Invalid price value
 */
abstract contract RootManagedCreationAndStorageFee is RootManaged, IRootManagedCreationAndStorageFee {
    /*************
     * VARIABLES *
     *************/
    uint128 internal _creationMinValue;
    uint128 internal _creationFee;
    uint128 internal _creationAndStorageFee;



    /*************
     * MODIFIERS *
     *************/
    modifier creationPaymentIsEnough() {
        require(msg.value >= _creationMinValue, 1100, "Need more money");
        _;
    }

    modifier creationPaymentIsEnoughPrice(uint128 price) {
        require(msg.value - _creationFee - _creationAndStorageFee  >= price, 1101, "Invalid price value");
        _;
    }



    /***************
     * CONSTRUCTOR *
     ***************/
    /**
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     * storageFee . Payment for create and store offer.
     */
    constructor(uint128 minValue, uint128 fee, uint128 storageFee) public accept {
        _creationMinValue = minValue;
        _creationFee = fee;
        _creationAndStorageFee = storageFee;
    }



    /***************************
     * EXTERNAL * ONLY MANAGER *
     ***************************/
    /**
     * Manager can change values, which are needed to create a token.
     * Be careful to set the correct values, otherwise the contract will not work.
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     * storageFee . Payment for create and store offer.
     */
    function setCreationFee(uint128 minValue, uint128 fee, uint128 storageFee) override external onlyManager accept {
        _creationMinValue = minValue;
        _creationFee = fee;
        _creationAndStorageFee = storageFee;
    }



    /*************
     * RECEIVERS *
     *************/
    /**
     * Returns values, which are needed to create a token.
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     * storageFee . Payment for create and store offer.
     */
    function receiveCreationFee() override external view responsible returns(uint128 minValue, uint128 fee, uint128 storageFee) {
        return{value: 0, bounce: false, flag: 64} getCreationFee();
    }



    /***********
     * GETTERS *
     ***********/
    /**
     * Returns values, which are needed to create a token.
     * minValue ... The minimum value that needs to be sent to the root to create a token.
     * fee ........ Payment for the work of the contract, plus money for the developers.
     * storageFee . Payment for create and store offer.
     */
    function getCreationFee() public view returns(uint128 minValue, uint128 fee, uint128 storageFee) {
        minValue = _creationMinValue;
        fee = _creationFee;
        storageFee = _creationAndStorageFee;
    }
}