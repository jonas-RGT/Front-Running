// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SecureBounty.sol";

contract SecureBountyTest is Test {
    SecureBounty bounty;
    address solver = address(1);
    address attacker = address(2);

    function setUp() public {
        bounty = new SecureBounty{value: 10 ether}();
        vm.deal(solver, 1 ether);
        vm.deal(attacker, 1 ether);
    }

    function testCommitRevealWorks() public {
        bytes32 salt = keccak256("salt");
        bytes32 commitHash = keccak256(abi.encodePacked("secret42", solver, salt));

        vm.prank(solver);
        bounty.commit(commitHash);

        vm.roll(block.number + 11);

        vm.prank(solver);
        bounty.reveal("secret42", salt);

        assertEq(solver.balance, 11 ether);
    }

    function testFrontRunRevealFails() public {
        bytes32 salt = keccak256("salt");
        bytes32 commitHash = keccak256(abi.encodePacked("secret42", solver, salt));

        vm.prank(solver);
        bounty.commit(commitHash);

        vm.roll(block.number + 11);

        vm.prank(attacker);
        vm.expectRevert("Invalid");
        bounty.reveal("secret42", salt);
    }
}
