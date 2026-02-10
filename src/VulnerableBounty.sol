// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VulnerableBounty {
    bytes32 public hashedAnswer;
    uint256 public reward;
    bool public solved;

    constructor(bytes32 _hashedAnswer) payable {
        hashedAnswer = _hashedAnswer;
        reward = msg.value;
    }

    /// @notice Submit the answer to claim the bounty
    /// @dev Answer is visible in the mempool before mining - vulnerable to displacement
    function submitAnswer(string calldata answer) external {
        require(!solved, "Already solved");
        require(keccak256(abi.encodePacked(answer)) == hashedAnswer, "Wrong answer");

        solved = true;
        (bool success,) = msg.sender.call{value: reward}("");
        require(success, "Transfer failed");
    }
}
