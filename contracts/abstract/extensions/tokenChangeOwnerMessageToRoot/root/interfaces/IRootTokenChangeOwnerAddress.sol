pragma ton-solidity ^0.44.0;

interface IRootTokenChangeOwnerAddress {
    /************
     * EXTERNAL *
     ************/
    /**
     * Call after change of address of token owner.
     * id .............. Id of token.
     * previousOwner ... Previous address of owner.
     * owner ........... New address of owner.
     */
    function tokenChangeOwner(uint128 id, address previousOwner, address owner) external;
}