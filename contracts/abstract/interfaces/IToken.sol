pragma ton-solidity ^0.44.0;

interface IToken {
    /*******************************************************
     * EXTERNAL * ONLY OWNER IF UNLOCKED OR LOCKED MANAGER *
     *******************************************************/
    /**
     * Owner can set manager and lock. To prevent manager from replacing during trading, he is locked.
     * If manager is already locked, call revert().
     * manager ...... Contract that governs this contract.
     * unlockTime ... UNIX time. Time when manager can be unlocked.
     */
    function lockManager(address manager, uint32 unlockTime) external;

    /**
     * Owner can lock manager. To prevent manager from replacing during trading, he is locked.
     * If manager is already locked, call revert().
     * unlockTime ... UNIX time. Time when manager can be unlocked.
     */
    function lock(uint32 unlockTime) external;



    /**********************************
     * EXTERNAL * ONLY LOCKED MANAGER *
     **********************************/
    /**
     * Manager can unlock himself.
     * If manager is already unlocked, call revert().
     */
    function unlock() external;
}