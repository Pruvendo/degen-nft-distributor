pragma ton-solidity ^0.44.0;

import "../../../TokenPublicKey.sol";

abstract contract TokenChangeOwnerEvent is TokenPublicKey {
    /**********
     * EVENTS *
     **********/
    event ChangeOwnerEvent(
        uint256 id,
        uint256 previousOwner,
        uint256 owner
    );

    /**
     * Call after change of public key of token owner.
     */
    function _onChangeOwner(uint256 previousOwner, uint256 owner) override internal {
        emit ChangeOwnerEvent(_id, previousOwner, owner);
    }
}