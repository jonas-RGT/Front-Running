// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SecureBounty {
    uint256 public reward;
    uint256 public constant WAIT_BLOCKS = 10;

    struct Commit {
        bytes32 hash;
        uint256 blockNumber;
        bool revealed;
    }

    mapping(address => Commit) public commits;

    constructor() payable {
        reward = msg.value;
    }

    function commit(bytes32 hash) external {
        require(commits[msg.sender].hash == bytes32(0), "Committed");
        commits[msg.sender] = Commit(hash, block.number, false);
    }

    function reveal(string calldata answer, bytes32 salt) external {
        Commit storage c = commits[msg.sender];
        require(!c.revealed, "Revealed");
        require(block.number >= c.blockNumber + WAIT_BLOCKS, "Too early");

        bytes32 h = keccak256(abi.encodePacked(answer, msg.sender, salt));
        require(h == c.hash, "Invalid");

        c.revealed = true;
        (bool ok,) = msg.sender.call{value: reward}("");
        require(ok);
    }
}
