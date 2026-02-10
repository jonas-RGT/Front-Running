// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SimpleToken.sol";

contract SecureSwap {
    SimpleToken public tokenA;
    SimpleToken public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = SimpleToken(_tokenA);
        tokenB = SimpleToken(_tokenB);
    }

    function addLiquidity(uint256 a, uint256 b) external {
        tokenA.transferFrom(msg.sender, address(this), a);
        tokenB.transferFrom(msg.sender, address(this), b);
        reserveA += a;
        reserveB += b;
    }

    function swapAForB(uint256 amountAIn, uint256 minBOut, uint256 deadline) external {
        require(block.timestamp <= deadline, "Expired");

        uint256 amountBOut = (reserveB * amountAIn) / (reserveA + amountAIn);
        require(amountBOut >= minBOut, "Slippage");

        tokenA.transferFrom(msg.sender, address(this), amountAIn);
        tokenB.transfer(msg.sender, amountBOut);

        reserveA += amountAIn;
        reserveB -= amountBOut;
    }
}
