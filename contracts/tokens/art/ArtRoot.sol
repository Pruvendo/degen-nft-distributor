pragma ton-solidity ^0.44.0;

import "../../abstract/Root.sol";
import "../../abstract/extensions/rootManaged/root/RootManaged.sol";
import "../../abstract/extensions/rootManaged/root/RootManagedCreationFee.sol";
import "../../abstract/extensions/rootManaged/root/RootManagedWithdraw.sol";
import "ArtToken.sol";
import "interfaces/IArtRoot.sol";

contract ArtRoot is Root, RootManaged, RootManagedCreationFee, RootManagedWithdraw, IArtRoot {

    /**
     * dataHash ....... Hash of zip archive generative NFT based on
     * traitsConfig ... Number of options for each particular trait
     */
    uint256 public dataHash;
    uint[] public traitsConfig;



    /***************
     * CONSTRUCTOR *
     ***************/
    /**
     * name ........ UTF8-encoded name of token. e.g. "CryptoKitties"
     * symbol ...... UTF8-encoded symbol of token. e.g. "CK"
     * tokenCode ... Code of token contract.
     */
    constructor(
        address manager,
        uint128 creationMinValue,
        uint128 creationFee,
        string  name,
        string  symbol,
        TvmCell tokenCode,
        uint[] traitsConfig_
    )
        public
        Root(name, symbol, tokenCode)
        RootManaged(manager)
        RootManagedCreationFee(creationMinValue, creationFee)
    {
        traitsConfig = traitsConfig_;
    }


    event TokenCreated(uint256 id, address addr);


    /************
     * EXTERNAL *
     ************/
    /**
     * Create token contract and returns address. Accept 0.1 ton and more.
     * owner ............... Address of token owner.
     * manager ............. Contract that governs token contract.
     *                       If you don't want to set the manager, use 0:000011112222...
     * managerUnlockTime ... UNIX time. Time when the manager can be unlocked.
     *                       If you don't want to set the manager, use 0.
     * addr ................ Address of the token contract.
     * creator ............. Address of creator.
     * creatorFees ......... Creator fee. e.g. 1 = 0.01%. 1 is minimum. 10_000 is maximum.
     * uniqueVector ........ Vector defining choices for each trait.
     */
    function create(
        address owner,
        address manager,
        uint32  managerUnlockTime,
        address creator,
        uint32  creatorFees,
        uint[] uniqueVector
    )
        override
        external
        responsible
        returns(
            address addr
        )
    {
        require(_isCorrectVector(uniqueVector));
        uint128 fee = (msg.pubkey() == tvm.pubkey()) ? 0 : _creationFee;
        uint128 value = msg.value - fee;
        uint256 id = _vectorToId(uniqueVector);
        addr = new ArtToken{
            code: _tokenCode,
            value: value,
            pubkey: tvm.pubkey(),
            varInit: {
                _root: address(this),
                _id: id
            }
        }(owner, manager, managerUnlockTime, creator, creatorFees, dataHash);
        emit TokenCreated(id, addr);
    }

    function _isCorrectVector(uint[] xs) inline internal view returns (bool) {
        if (xs.length != traitsConfig.length) {
            return false;
        }

        for (uint i = 0; i < xs.length; i++) {
            if (xs[i] >= traitsConfig[i]) {
                return false;
            }
        }
        return true;
    }

    function _vectorToId(uint[] xs) inline internal view returns (uint256 resultId) {
        resultId = xs[0];
        for (uint i = 1; i < xs.length; i++) {
            resultId = resultId * traitsConfig[i] + xs[i];
        }
    }

    function _idToVector(uint256 id) inline internal view returns (uint[] xs) {
        xs = new uint[](traitsConfig.length);
        for (uint i = xs.length - 1; i >= 0; i--) {
            xs[i] = uint(id % traitsConfig[i]);
            id /= traitsConfig[i];
        }
    }

    /*************
     * RECEIVERS *
     *************/
    /**
     * Receive the address of the token contract calculated by id.
     * id ..... Id of token.
     * addr ... Address of the token contract.
     */
    function receiveTokenAddress(uint128 id) override external view responsible returns(address addr) {
        return{value: 0, bounce: false, flag: 64} getTokenAddress(id);
    }



    /***********
     * GETTERS *
     ***********/
     /**
     * Returns the address of the token contract calculated by id.
     * id ..... Id of token.
     * addr ... Address of the token contract.
     */
    function getTokenAddress(uint128 id) override public view returns(address addr) {
        TvmCell stateInit = tvm.buildStateInit({
            contr: ArtToken,
            varInit: {
                _root: address(this),
                _id: id
            },
            pubkey: tvm.pubkey(),
            code: _tokenCode
        });
        return address(tvm.hash(stateInit));
    }
}