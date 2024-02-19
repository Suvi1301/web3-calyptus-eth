// SPDX-License-Identifier: MIT
pragma solidity  0.8.7;

contract NumberStorage {
    uint num;

    function setNumber(uint _num) public {
        num = _num;
    }

    function getNumber() public view returns(uint) {
        return num;
    }
}