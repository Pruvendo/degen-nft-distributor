pragma ton-solidity ^0.44.0;

interface ITokenPublicKey {
    /*******************************************************
     * EXTERNAL * ONLY OWNER IF UNLOCKED OR LOCKED MANAGER *
     *******************************************************/
    /**
     * Owner or manager can change token owner.
     * owner ... Public key of token owner.
     */
    function changeOwner(uint256 owner) external;



    /*************
     * RECEIVERS *
     *************/
    /**
     * Returns basic information about token.
     * root ............... Address of root contract.
     * id ................. Id of token.
     * publicKey .......... Public key of root contract. tvm.pubkey()
     * owner .............. Public key of token owner.
     * manager ............ Contract that governs this contract.
     * managerUnlockTime .. UNIX time. Time when manager can be unlocked.
     */
    function receiveInfo() external view responsible returns(
            address root,
            uint128 id,
            uint256 publicKey,
            uint256 owner,
            address manager,
            uint32  managerUnlockTime
        );
}