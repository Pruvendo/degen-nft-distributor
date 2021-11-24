pragma ton-solidity ^0.44.0;

interface ITokenAddress {
    /*******************************************************
     * EXTERNAL * ONLY OWNER IF UNLOCKED OR LOCKED MANAGER *
     *******************************************************/
    /**
     * Owner or manager can change token owner address.
     * owner ... Address of token owner.
     */
    function changeOwner(address owner) external;



    /*************
     * RECEIVERS *
     *************/
    /**
     * Returns basic information about token.
     * root ................ Address of root contract.
     * id .................. Id of token.
     * publicKey ........... Public key of root contract. tvm.pubkey()
     * owner ............... Address of token owner.
     * manager ............. Contract that governs this contract.
     * managerUnlockTime ... UNIX time. Time when manager can be unlocked.
     */
    function receiveInfo() external view responsible returns(
            address root,
            uint256 id,
            uint256 publicKey,
            address owner,
            address manager,
            uint32  managerUnlockTime
        );
}