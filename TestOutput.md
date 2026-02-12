Ran 1 test for test/DisplacementAttack.t.sol:DisplacementAttackTest     
[PASS] testDisplacementAttack() (gas: 418721)
Traces:
  [418721] DisplacementAttackTest::testDisplacementAttack()
    ├─ [339234] → new VulnerableBounty@0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
    │   └─ ← [Return] 1472 bytes of code
    ├─ [0] VM::deal(ECRecover: [0x0000000000000000000000000000000000000001], 1000000000000000000 [1e18])    
    │   └─ ← [Return]
    ├─ [0] VM::deal(SHA-256: [0x0000000000000000000000000000000000000002], 1000000000000000000 [1e18])      
    │   └─ ← [Return]
    ├─ [0] VM::prank(ECRecover: [0x0000000000000000000000000000000000000001])
    │   └─ ← [Return]
    ├─ [33516] VulnerableBounty::submitAnswer("secret42")
    │   ├─ [3000] PRECOMPILES::ecrecover{value: 10000000000000000000}(0x)
    │   │   └─ ← [Return] 0x        
    │   └─ ← [Stop]
    ├─ [0] VM::prank(SHA-256: [0x0000000000000000000000000000000000000002])
    │   └─ ← [Return]
    ├─ [0] VM::expectRevert(custom error 0xf28dceb3:  Already solved)   
    │   └─ ← [Return]
    ├─ [947] VulnerableBounty::submitAnswer("secret42")
    │   └─ ← [Revert] Already solved
    └─ ← [Stop]

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 23.70ms (12.13ms CPU time)

Ran 2 tests for test/SecureBounty.t.sol:SecureBountyTest
[PASS] testCommitRevealWorks() (gas: 98314)
Traces:
  [98314] SecureBountyTest::testCommitRevealWorks()
    ├─ [0] VM::prank(ECRecover: [0x0000000000000000000000000000000000000001])
    │   └─ ← [Return]
    ├─ [47307] SecureBounty::commit(0x16279f301bc112664c863524dece4cf44035a45feed27717b5c36f67fd27fc03)     
    │   └─ ← [Stop]
    ├─ [0] VM::roll(12)
    │   └─ ← [Return]
    ├─ [0] VM::prank(ECRecover: [0x0000000000000000000000000000000000000001])
    │   └─ ← [Return]
    ├─ [37068] SecureBounty::reveal("secret42", 0xa05e334153147e75f3f416139b5109d1179cb56fef6a4ecb4c4cbc92a7c37b70)
    │   ├─ [3000] PRECOMPILES::ecrecover{value: 10000000000000000000}(0x)
    │   │   └─ ← [Return] 0x        
    │   └─ ← [Stop]
    └─ ← [Stop]

[PASS] testFrontRunRevealFails() (gas: 71960)
Traces:
  [71960] SecureBountyTest::testFrontRunRevealFails()
    ├─ [0] VM::prank(ECRecover: [0x0000000000000000000000000000000000000001])
    │   └─ ← [Return]
    ├─ [47307] SecureBounty::commit(0x16279f301bc112664c863524dece4cf44035a45feed27717b5c36f67fd27fc03)     
    │   └─ ← [Stop]
    ├─ [0] VM::roll(12)
    │   └─ ← [Return]
    ├─ [0] VM::prank(SHA-256: [0x0000000000000000000000000000000000000002])
    │   └─ ← [Return]
    ├─ [0] VM::expectRevert(custom error 0xf28dceb3:  Invalid)
    │   └─ ← [Return]
    ├─ [8484] SecureBounty::reveal("secret42", 0xa05e334153147e75f3f416139b5109d1179cb56fef6a4ecb4c4cbc92a7c37b70)
    │   └─ ← [Revert] Invalid       
    └─ ← [Stop]

Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 24.05ms (2.77ms CPU time)

Ran 1 test for test/SandwichAttack.t.sol:SandwichAttackTest
[PASS] testSandwichAttack() (gas: 153093)
Traces:
  [177793] SandwichAttackTest::testSandwichAttack()
    ├─ [1564] VulnerableSwap::getAmountOut(10000000000000000000000 [1e22], 100000000000000000000000 [1e23], 100000000000000000000000 [1e23]) [staticcall]
    │   └─ ← [Return] 9090909090909090909090 [9.09e21]
    ├─ [0] VM::prank(ECRecover: [0x0000000000000000000000000000000000000001])
    │   └─ ← [Return]
    ├─ [69317] VulnerableSwap::swapAForB(30000000000000000000000 [3e22])
    │   ├─ [16061] SimpleToken::transferFrom(ECRecover: [0x0000000000000000000000000000000000000001], VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], 30000000000000000000000 [3e22])
    │   │   ├─ emit Transfer(from: ECRecover: [0x0000000000000000000000000000000000000001], to: VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], value: 30000000000000000000000 [3e22])
    │   │   └─ ← [Return] true      
    │   ├─ [30545] SimpleToken::transfer(ECRecover: [0x0000000000000000000000000000000000000001], 23076923076923076923076 [2.307e22])
    │   │   ├─ emit Transfer(from: VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], to: ECRecover: [0x0000000000000000000000000000000000000001], value: 23076923076923076923076 [2.307e22])
    │   │   └─ ← [Return] true      
    │   └─ ← [Stop]
    ├─ [0] VM::prank(SHA-256: [0x0000000000000000000000000000000000000002])
    │   └─ ← [Return]
    ├─ [41117] VulnerableSwap::swapAForB(10000000000000000000000 [1e22])
    │   ├─ [11261] SimpleToken::transferFrom(SHA-256: [0x0000000000000000000000000000000000000002], VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], 10000000000000000000000 [1e22])
    │   │   ├─ emit Transfer(from: SHA-256: [0x0000000000000000000000000000000000000002], to: VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], value: 10000000000000000000000 [1e22])
    │   │   └─ ← [Return] true      
    │   ├─ [25745] SimpleToken::transfer(SHA-256: [0x0000000000000000000000000000000000000002], 5494505494505494505494 [5.494e21])
    │   │   ├─ emit Transfer(from: VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], to: SHA-256: [0x0000000000000000000000000000000000000002], value: 5494505494505494505494 [5.494e21])
    │   │   └─ ← [Return] true      
    │   └─ ← [Stop]
    ├─ [850] SimpleToken::balanceOf(SHA-256: [0x0000000000000000000000000000000000000002]) [staticcall]     
    │   └─ ← [Return] 5494505494505494505494 [5.494e21]
    ├─ [850] SimpleToken::balanceOf(ECRecover: [0x0000000000000000000000000000000000000001]) [staticcall]   
    │   └─ ← [Return] 23076923076923076923076 [2.307e22]
    ├─ [0] VM::prank(ECRecover: [0x0000000000000000000000000000000000000001])
    │   └─ ← [Return]
    ├─ [25296] SimpleToken::approve(VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], 115792089237316195423570985008687907853269984665640564039457584007913129639935 [1.157e77])
    │   ├─ emit Approval(owner: ECRecover: [0x0000000000000000000000000000000000000001], spender: VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], value: 115792089237316195423570985008687907853269984665640564039457584007913129639935 [1.157e77])
    │   └─ ← [Return] true
    ├─ [0] VM::prank(ECRecover: [0x0000000000000000000000000000000000000001])
    │   └─ ← [Return]
    ├─ [12482] VulnerableSwap::swapBForA(23076923076923076923076 [2.307e22])
    │   ├─ [4461] SimpleToken::transferFrom(ECRecover: [0x0000000000000000000000000000000000000001], VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], 23076923076923076923076 [2.307e22])
    │   │   ├─ emit Transfer(from: ECRecover: [0x0000000000000000000000000000000000000001], to: VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], value: 23076923076923076923076 [2.307e22])
    │   │   └─ ← [Return] true      
    │   ├─ [3845] SimpleToken::transfer(ECRecover: [0x0000000000000000000000000000000000000001], 34186046511627906976742 [3.418e22])
    │   │   ├─ emit Transfer(from: VulnerableSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], to: ECRecover: [0x0000000000000000000000000000000000000001], value: 34186046511627906976742 [3.418e22])
    │   │   └─ ← [Return] true      
    │   └─ ← [Stop]
    ├─ [850] SimpleToken::balanceOf(ECRecover: [0x0000000000000000000000000000000000000001]) [staticcall]   
    │   └─ ← [Return] 54186046511627906976742 [5.418e22]
    └─ ← [Stop]

Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 5.04ms (1.26ms CPU time)

Ran 2 tests for test/SecureSwap.t.sol:SecureSwapTest
[PASS] testExpiredReverts() (gas: 13509)
HA-256: [0x0000000000000000000000000000000000000002], to: SecureSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], value: 30000000000000000000000 [3e22])
    │   │   └─ ← [Return] true
    │   ├─ [30545] SimpleToken::transfer(SHA-256: [0x0000000000000000000000000000000000000002], 23076923076923076923076 [2.307e22])   
    │   │   ├─ emit Transfer(from: SecureSwap: [0xF62849F9A0B5Bf2913b396098F7c7019b51A820a], to: SHA-256: [0x0000000000000000000000000000000000000002], value: 23076923076923076923076 [2.307e22])
    │   │   └─ ← [Return] true
    │   └─ ← [Stop]
    ├─ [0] VM::prank(ECRecover: [0x0000000000000000000000000000000000000001])
    │   └─ ← [Return]
    ├─ [0] VM::expectRevert(custom error 0xf28dceb3: Slippage)
    │   └─ ← [Return]
    ├─ [1954] SecureSwap::swapAForB(10000000000000000000000 [1e22], 9500000000000000000000 [9.5e21], 2)
    │   └─ ← [Revert] Slippage
    └─ ← [Stop]

Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 6.05ms (3.79ms CPU time)

Ran 4 test suites in 4.57s (58.84ms CPU time): 6 tests passed, 0 failed, 0 skipped (6 total tests)
