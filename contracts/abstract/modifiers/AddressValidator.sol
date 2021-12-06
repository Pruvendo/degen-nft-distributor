pragma ton-solidity ^0.44.0;

/**
 * Error codes
 *     201 - Address can't be null
 */
abstract contract AddressValidator {
    /*************
     * MODIFIERS *
     *************/
    modifier addressIsNotNull(address addr) {
        require(addr.value != 0, 201, "Address can't be null");
        _;
    }
}