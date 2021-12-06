pragma ton-solidity ^0.44.0;

interface IRootManagedWithdraw {
    /***************************
     * EXTERNAL * ONLY MANAGER *
     ***************************/
    /**
     * Manager can withdraw money from root contract.
     * addr ..... Destination address.
     * value .... Value to withdraw.
     * bounce ... Use false to transfer funds to a non-existing contract to create it.
     */
    function withdraw(address addr, uint128 value, bool bounce) external view;
}