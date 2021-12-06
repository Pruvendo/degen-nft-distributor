pragma ton-solidity ^0.44.0;

/**
 * Error codes
 *     200 - Public key can't be null
 */
abstract contract PublicKeyValidator {
    /*************
     * MODIFIERS *
     *************/
    modifier publicKeyIsNotNull(uint256 publicKey) {
        require(publicKey != 0, 200, "Public key can't be null");
        _;
    }
}