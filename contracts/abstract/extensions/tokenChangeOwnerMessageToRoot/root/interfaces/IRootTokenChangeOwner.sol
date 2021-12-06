pragma ton-solidity ^0.44.0;

interface IRootTokenChangeOwner {
    /************
     * EXTERNAL *
     ************/
    /**
     * Call after change of contract owner.
     * id .............. Id of token.
     * previousOwner ... Previous public key of token owner.
     * owner ........... New public key of token owner.
     */
    function tokenChangeOwner(uint128 id, uint256 previousOwner, uint256 owner) external;
}