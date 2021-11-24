pragma ton-solidity ^0.44.0;

interface IRoot {
    /*************
     * RECEIVERS *
     *************/
    /**
     * Returns basic information about root of token.
     * name .......... UTF8-encoded name of token. e.g. "CryptoKitties"
     * symbol ........ UTF8-encoded symbol of token. e.g. "CK"
     * totalSupply ... Number of tokens created.
     * publicKey ..... Public key of root contract. tvm.pubkey()
     */
    function receiveInfo() external view responsible returns(
            string  name,
            string  symbol,
            uint128 totalSupply,
            uint256 publicKey
        );

    /**
     * Returns the address of token contract calculated by id.
     * id ..... Id of token.
     * addr ... Address of the token contract.
     */
    function receiveTokenAddress(uint128 id) external view responsible returns(address addr);
}