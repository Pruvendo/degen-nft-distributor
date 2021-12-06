pragma ton-solidity ^0.44.0;

abstract contract Accept {
    /*************
     * MODIFIERS *
     *************/
    modifier accept {
        tvm.accept();
        _;
    }
}