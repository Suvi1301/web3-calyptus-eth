// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("SuviCoin", "SUVC") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }

    function mint(uint _qty) public {
        _mint(msg.sender, _qty);
    }

    function burn(uint _qty) public {
        _burn(msg.sender, _qty);
    }

    /*
    For transferring the tokens from sender’s account to receiver’s account,
    we can use the transfer function already implemented in ERC20.sol as it is public. 
    */
}