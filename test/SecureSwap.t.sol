// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SecureSwap.sol";
import "../src/SimpleToken.sol";

/*
Bonus: MEV Protection Research

Flashbots Protect is a service that allows users to submit transactions directly to miners (or validators)
through a private relay, bypassing the public mempool. By keeping transactions hidden until inclusion in a block,
it prevents bots from seeing pending swaps and executing front-running, sandwich, or displacement attacks.
A private mempool works similarly by restricting transaction visibility to trusted parties or the miner/validator
itself, reducing exposure to MEV bots scanning the public mempool.

Slippage protection alone cannot fully prevent MEV extraction because users must set a minimum acceptable output.
If the slippage tolerance is too high, a bot can still profit by sandwiching or manipulating the price
within that tolerance window. Conversely, if it is too tight, legitimate transactions may fail, making it a
trade-off rather than a complete MEV defense.
*/

contract SecureSwapTest is Test {
    SecureSwap swap;
    SimpleToken a;
    SimpleToken b;

    address victim = address(1);
    address attacker = address(2);

    function setUp() public {
        a = new SimpleToken("A", "A", 1_000_000 ether);
        b = new SimpleToken("B", "B", 1_000_000 ether);
        swap = new SecureSwap(address(a), address(b));

        a.approve(address(swap), type(uint256).max);
        b.approve(address(swap), type(uint256).max);
        swap.addLiquidity(100_000 ether, 100_000 ether);

        a.transfer(victim, 10_000 ether);
        a.transfer(attacker, 50_000 ether);

        vm.prank(victim);
        a.approve(address(swap), type(uint256).max);

        vm.prank(attacker);
        a.approve(address(swap), type(uint256).max);
    }

    function testSandwichBlocked() public {
        vm.prank(attacker);
        swap.swapAForB(30_000 ether, 1, block.timestamp + 1);

        vm.prank(victim);
        vm.expectRevert("Slippage");
        swap.swapAForB(10_000 ether, 9_500 ether, block.timestamp + 1);
    }

    function testExpiredReverts() public {
        vm.warp(block.timestamp + 100);

        vm.prank(victim);
        vm.expectRevert("Expired");
        swap.swapAForB(1 ether, 1, block.timestamp - 1);
    }
}
