pragma ton-solidity ^0.44.0;

import "interfaces/IRoot.sol";
import "./modifiers/Accept.sol";

/**
 * ███╗   ██╗███████╗████████╗    ██████╗  ██████╗  ██████╗ ████████╗
 * ████╗  ██║██╔════╝╚══██╔══╝    ██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝
 * ██╔██╗ ██║█████╗     ██║       ██████╔╝██║   ██║██║   ██║   ██║
 * ██║╚██╗██║██╔══╝     ██║       ██╔══██╗██║   ██║██║   ██║   ██║
 * ██║ ╚████║██║        ██║       ██║  ██║╚██████╔╝╚██████╔╝   ██║
 * ╚═╝  ╚═══╝╚═╝        ╚═╝       ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝
 * Root of non-fungible token
 *
 * Error codes
 *     100 - Method for the owner only
 */
abstract contract Root is IRoot, Accept {
    /*************
     * VARIABLES *
     *************/
    string  private  _name;
    string  private  _symbol;
    TvmCell internal _tokenCode;
    uint128 internal _totalSupply;



    /*************
     * MODIFIERS *
     *************/
    modifier onlyOwner {
        require(msg.pubkey() == tvm.pubkey(), 100, "Method for the owner only");
        _;
    }



    /***************
     * CONSTRUCTOR *
     ***************/
    /**
     * name ........ UTF8-encoded name of token. e.g. "CryptoKitties"
     * symbol ...... UTF8-encoded symbol of token. e.g. "CK"
     * tokenCode ... Code of token contract.
     */
    constructor(string name, string symbol, TvmCell tokenCode)
        public
        onlyOwner
        accept
    {
        _name = name;
        _symbol = symbol;
        _tokenCode = tokenCode;
    }



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
    function receiveInfo() override external view responsible returns(
            string  name,
            string  symbol,
            uint128 totalSupply,
            uint256 publicKey
        )
    {
        return{value: 0, bounce: false, flag: 64} getInfo();
    }

    /**
     * Returns the address of token contract calculated by id.
     * id ..... Id of token.
     * addr ... Address of the token contract.
     */
    function receiveTokenAddress(uint128 id) override virtual external view responsible returns(address addr);



    /***********
     * GETTERS *
     ***********/
    /**
     * Returns basic information about the root of the token.
     * name .......... UTF8-encoded name of token. e.g. "CryptoKitties"
     * symbol ........ UTF8-encoded symbol of token. e.g. "CK"
     * totalSupply ... Number of tokens created.
     * publicKey ..... Public key of root contract. tvm.pubkey()
     */
    function getInfo() public view returns(
            string  name,
            string  symbol,
            uint128 totalSupply,
            uint256 publicKey
        )
    {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        publicKey = tvm.pubkey();
    }

    /**
     * Returns the address of the token contract calculated by id.
     * id ..... Id of token.
     * addr ... Address of the token contract.
     *
     * Example:
     *     TvmCell stateInit = tvm.buildStateInit({
     *         contr: Token,
     *         varInit: {
     *             _root: address(this),
     *             _id: id
     *         },
     *         pubkey: tvm.pubkey(),
     *         code: _tokenCode
     *     });
     *    return address(tvm.hash(stateInit));
     */
    function getTokenAddress(uint128 id) virtual public view returns(address addr);

    /**
     * Returns code of token.
     * code ... Code of token.
     */
    function getTokenCode() public view returns(TvmCell code) {
        return _tokenCode;
    }
}