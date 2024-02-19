// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Example {
    uint8 public variable;

    function decrement() public {
        variable--;
    }

    function increment() public {
        variable++;
    }
}
 
contract MyContract{
 
    function checkEqual(address _acc1, address _acc2) public pure returns (bool){
        return (_acc1 == _acc2);
    }

    function getBalance(address _account) public view returns(uint){
        return _account.balance;
    }

}
