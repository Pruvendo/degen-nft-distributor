pragma ton-solidity ^0.44.0;

import "../../../TokenAddress.sol";

abstract contract TokenChangeOwnerAddressEvent is TokenAddress {
    /**********
     * EVENTS *
     **********/
    event ChangeOwnerEvent(
        uint256 id,
        address previousOwner,
        address owner
    );

    /**
     * Call after change of address of token owner.
     */
    function _onChangeOwner(address previousOwner, address owner) override internal {
        emit ChangeOwnerEvent(_id, previousOwner, owner);
    }
}