// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./SimpleToken.sol";

contract VulnerableSwap {
    SimpleToken public tokenA;
    SimpleToken public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = SimpleToken(_tokenA);
        tokenB = SimpleToken(_tokenB);
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external {
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);
        reserveA += amountA;
        reserveB += amountB;
    }

    /// @notice Swap tokenA for tokenB using constant product formula (x * y = k)
    /// @dev No slippage protection - vulnerable to front-running
    function swapAForB(uint256 amountAIn) external {
        require(amountAIn > 0, "Amount must be > 0");

        // Calculate output using constant product: (reserveA + amountIn) * (reserveB - amountOut) = reserveA * reserveB
        uint256 amountBOut = (reserveB * amountAIn) / (reserveA + amountAIn);
        require(amountBOut > 0, "Insufficient output");

        tokenA.transferFrom(msg.sender, address(this), amountAIn);
        tokenB.transfer(msg.sender, amountBOut);

        reserveA += amountAIn;
        reserveB -= amountBOut;
    }

    /// @notice Swap tokenB for tokenA
    function swapBForA(uint256 amountBIn) external {
        require(amountBIn > 0, "Amount must be > 0");

        uint256 amountAOut = (reserveA * amountBIn) / (reserveB + amountBIn);
        require(amountAOut > 0, "Insufficient output");

        tokenB.transferFrom(msg.sender, address(this), amountBIn);
        tokenA.transfer(msg.sender, amountAOut);

        reserveB += amountBIn;
        reserveA -= amountAOut;
    }

    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) public pure returns (uint256) {
        return (reserveOut * amountIn) / (reserveIn + amountIn);
    }
}
