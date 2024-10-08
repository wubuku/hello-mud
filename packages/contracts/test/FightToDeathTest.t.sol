// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/utils/FightToDeath.sol";
import "../src/utils/TsRandomUtil.sol";

contract FightToDeathTest is Test {
  using FightToDeath for *;

  function setUp() public {
      //
  }

  function testFightToDeath() public {
    bytes memory seed = "gagjalgsssxsffi";
    uint32 selfAttack = 5;
    uint32 selfProtection = 5; //6;
    uint32 selfHealth = 5; //4;
    uint32 opponentAttack = 5;
    uint32 opponentProtection = 5; //6;
    uint32 opponentHealth = 5; //9;

    uint256 winCount = 0;
    uint256 loseCount = 0;

    for (uint256 i = 0; i < 100; i++) {
      // 模拟时间增加
      vm.warp(block.timestamp + 232324);

      // 更新种子
      seed = abi.encodePacked(seed, uint8(i));

      (uint32 selfDamageTaken, uint32 opponentDamageTaken) = FightToDeath.perform(
        FightToDeath.FightToDeathParams(
          seed,
          selfAttack,
          selfProtection,
          selfHealth,
          opponentAttack,
          opponentProtection,
          opponentHealth
        )
      );

      console.log("Self damage taken:", selfDamageTaken);
      console.log("Opponent damage taken:", opponentDamageTaken);

      // 断言检查
      assertTrue(!(selfDamageTaken == selfHealth && opponentDamageTaken == opponentHealth), "Both parties cannot die");
      assertTrue(selfDamageTaken == selfHealth || opponentDamageTaken == opponentHealth, "One party must die");

      if (selfDamageTaken != selfHealth) {
        winCount++;
      } else {
        loseCount++;
      }
    }

    console.log("Win count:", winCount);
    console.log("Lose count:", loseCount);
  }

  function testEdgeCases() public view {
    bytes memory seed = "testSeed";

    // Test both parties have only 1 point of health
    (uint32 selfDamage, uint32 opponentDamage) = FightToDeath.perform(
      FightToDeath.FightToDeathParams(seed, 5, 5, 1, 5, 5, 1)
    );
    //assertEq(selfDamage, 1, "Self should take 1 damage");
    //assertEq(opponentDamage, 1, "Opponent should take 1 damage");
    console.log("testEdgeCases(), Self damage:", selfDamage);
    console.log("testEdgeCases(), Opponent damage:", opponentDamage);

    // Test one party has 1 point of health and the other has more than 2 points
    (selfDamage, opponentDamage) = FightToDeath.perform(FightToDeath.FightToDeathParams(seed, 5, 5, 1, 5, 5, 3));
    //assertEq(selfDamage, 1, "Self should take 1 damage");
    // assertEq(opponentDamage, 1, "Opponent should take 1 damage");
    console.log("testEdgeCases(), Self damage:", selfDamage);
    console.log("testEdgeCases(), Opponent damage:", opponentDamage);

    (selfDamage, opponentDamage) = FightToDeath.perform(FightToDeath.FightToDeathParams(seed, 5, 5, 3, 5, 5, 1));
    // assertEq(selfDamage, 1, "Self should take 1 damage");
    // assertEq(opponentDamage, 1, "Opponent should take 1 damage");
    console.log("testEdgeCases(), Self damage:", selfDamage);
    console.log("testEdgeCases(), Opponent damage:", opponentDamage);
  }

  function testInvalidInputs() public {
    bytes memory seed = "testSeed";

    // Test self health is 0
    vm.expectRevert(abi.encodeWithSelector(FightToDeath.InvalidSelfHealth.selector, 0));
    FightToDeath.perform(FightToDeath.FightToDeathParams(seed, 5, 5, 0, 5, 5, 5));
    // Test opponent health is 0
    vm.expectRevert(abi.encodeWithSelector(FightToDeath.InvalidSelfHealth.selector, 0));
    FightToDeath.perform(FightToDeath.FightToDeathParams(seed, 5, 5, 5, 5, 5, 0));
  }
}
