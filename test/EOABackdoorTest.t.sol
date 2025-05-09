// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console, Vm} from "forge-std/Test.sol";
import {EOABackdoor} from "src/EOABackdoor.sol";
import {MockToken} from "src/MockToken.sol";

contract EOABackdoorTest is Test {
    EOABackdoor public eoa;

    MockToken public tokenA;
    MockToken public tokenC;
    MockToken public tokenB;
    uint256 public ANVIL_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public ANVILL_NINE_KEY =
        0x2a871d0798f97d79848a013d4936a73bf4cc922c825d33c1cf7073dff6d409c6;
    address public ANVILL_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address public ANVILL_NINE_ADDRESS =
        0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;

    function setUp() public {
        vm.startPrank(ANVILL_ADDRESS);
        tokenA = new MockToken();
        tokenB = new MockToken();
        tokenC = new MockToken();
        vm.stopPrank();

        vm.deal(ANVILL_ADDRESS, 1 ether);
        eoa = new EOABackdoor(tokenA, tokenB, tokenC);
    }

    function testBackdoorOneTx() public {
        assert(tokenA.balanceOf(ANVILL_ADDRESS) > 0);
        assert(tokenC.balanceOf(ANVILL_ADDRESS) > 0);
        assert(tokenB.balanceOf(ANVILL_ADDRESS) > 0);

        //START TX
        vm.signAndAttachDelegation(address(eoa), ANVIL_KEY);
        vm.startPrank(ANVILL_ADDRESS);
        EOABackdoor(ANVILL_ADDRESS).increment();
        //END TX

        assert(tokenA.balanceOf(ANVILL_ADDRESS) == 0);
        assert(tokenC.balanceOf(ANVILL_ADDRESS) == 0);
        assert(tokenB.balanceOf(ANVILL_ADDRESS) == 0);
    }

    function testBackdoorNoTx() public {
        assert(tokenA.balanceOf(ANVILL_ADDRESS) > 0);
        assert(tokenC.balanceOf(ANVILL_ADDRESS) > 0);
        assert(tokenB.balanceOf(ANVILL_ADDRESS) > 0);

        //START TX
        vm.signAndAttachDelegation(address(eoa), ANVIL_KEY);
        vm.startPrank(ANVILL_ADDRESS);
        EOABackdoor(ANVILL_ADDRESS).increment();
        //END TX

        Vm.SignedDelegation memory signnedDelegation = vm.signDelegation(
            address(eoa),
            ANVIL_KEY
        );

        vm.attachDelegation(signnedDelegation);
        vm.startPrank(ANVILL_NINE_ADDRESS);
        EOABackdoor(ANVILL_ADDRESS).increment();

        assert(tokenA.balanceOf(ANVILL_ADDRESS) == 0);
        assert(tokenC.balanceOf(ANVILL_ADDRESS) == 0);
        assert(tokenB.balanceOf(ANVILL_ADDRESS) == 0);
    }
}
