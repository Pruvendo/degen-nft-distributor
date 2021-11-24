pragma ton-solidity ^0.44.0;

import "./RootManaged.sol";
import "./interfaces/IRootManagedWithdraw.sol";

abstract contract RootManagedWithdraw is RootManaged, IRootManagedWithdraw {
    /***************************
     * EXTERNAL * ONLY MANAGER *
     ***************************/
    /**
     * Manager can withdraw money from root contract.
     * addr ..... Destination address.
     * value .... Value to withdraw.
     * bounce ... Use false to transfer funds to a non-existing contract to create it.
     */
    function withdraw(address addr, uint128 value, bool bounce) override external view onlyManager accept {
        addr.transfer(value, bounce);
    }
}