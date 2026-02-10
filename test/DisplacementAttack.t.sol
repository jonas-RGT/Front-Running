// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VulnerableBounty.sol";

contract DisplacementAttackTest is Test {
    address attacker = address(1);
    address solver = address(2);

    function testDisplacementAttack() public {
        bytes32 hash = keccak256(abi.encodePacked("secret42"));
        VulnerableBounty bounty = new VulnerableBounty{value: 10 ether}(hash);

        vm.deal(attacker, 1 ether);
        vm.deal(solver, 1 ether);

        vm.prank(attacker);
        bounty.submitAnswer("secret42");

        vm.prank(solver);
        vm.expectRevert("Already solved");
        bounty.submitAnswer("secret42");

        assertEq(attacker.balance, 11 ether);
    }
}
