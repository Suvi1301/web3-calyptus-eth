// SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;

contract MyContract {
    uint num;

    function increment() public {
        num++;
    }

    function decrement() public {
        num--;
    }

    function getNum() public view returns(uint) {
        return num;
    }
}

