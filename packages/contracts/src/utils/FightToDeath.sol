// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { TsRandomUtil } from "./TsRandomUtil.sol";

library FightToDeath {
  error InvalidSelfHealth();
  error InvalidOpponentHealth();
  error BothAlive();
  error BothDead();

  function perform(
    bytes memory seed,
    uint32 selfAttack,
    uint32 selfProtection,
    uint32 selfHealth,
    uint32 opponentAttack,
    uint32 opponentProtection,
    uint32 opponentHealth
  ) internal view returns (uint32, uint32) {
    if (selfHealth == 0) revert InvalidSelfHealth();
    if (opponentHealth == 0) revert InvalidOpponentHealth();

    if ((selfHealth == 1 && opponentHealth > 2) || (opponentHealth == 1 && selfHealth > 2)) {
      return (1, 1);
    }

    (bool selfDamageDeltaRightShift, uint32 selfDamageNumerator, uint32 selfDamageDenominator) = calculateDamageFactors(
      selfHealth,
      opponentHealth,
      selfProtection,
      opponentAttack
    );

    (
      bool opponentDamageDeltaRightShift,
      uint32 opponentDamageNumerator,
      uint32 opponentDamageDenominator
    ) = calculateDamageFactors(opponentHealth, selfHealth, opponentProtection, selfAttack);

    uint32 scalingFactor = 10_000;
    selfDamageNumerator *= scalingFactor;
    selfDamageDenominator *= scalingFactor;
    opponentDamageNumerator *= scalingFactor;
    opponentDamageDenominator *= scalingFactor;

    selfDamageNumerator = adjustDamageNumerator(
      selfDamageNumerator,
      selfDamageDenominator,
      selfDamageDeltaRightShift,
      selfHealth,
      opponentHealth
    );

    opponentDamageNumerator = adjustDamageNumerator(
      opponentDamageNumerator,
      opponentDamageDenominator,
      opponentDamageDeltaRightShift,
      opponentHealth,
      selfHealth
    );

    uint32 selfDamageDelta = (25 * selfDamageNumerator) / selfDamageDenominator;
    uint32 opponentDamageDelta = (25 * opponentDamageNumerator) / opponentDamageDenominator;

    uint32[] memory selfDamageProbabilities = calculateDamageProbabilities(selfDamageDelta, selfDamageDeltaRightShift);
    uint32[] memory opponentDamageProbabilities = calculateDamageProbabilities(
      opponentDamageDelta,
      opponentDamageDeltaRightShift
    );

    (uint64 random1, uint64 random2, uint64 random3, ) = TsRandomUtil.get4U64(seed);
    random1 = random1 % 100;
    random2 = random2 % 100;

    uint32 selfDamageTaken = 0;
    uint32 opponentDamageTaken = 0;

    for (uint32 i = 0; i < 4; i++) {
      if (uint32(random1) < selfDamageProbabilities[i]) {
        selfDamageTaken = (selfHealth * 25 * (i + 1)) / 100;
        break;
      }
    }

    for (uint32 i = 0; i < 4; i++) {
      if (uint32(random2) < opponentDamageProbabilities[i]) {
        opponentDamageTaken = (opponentHealth * 25 * (i + 1)) / 100;
        break;
      }
    }

    if (selfDamageTaken != selfHealth && opponentDamageTaken != opponentHealth) {
      // One must die
      uint256 selfDamageTakenX = uint256(selfDamageTaken) * opponentHealth;
      uint256 opponentDamageTakenX = uint256(opponentDamageTaken) * selfHealth;
      if (selfDamageTakenX > opponentDamageTakenX) {
        selfDamageTaken = selfHealth;
      } else if (selfDamageTakenX == opponentDamageTakenX && random3 % 2 == 0) {
        selfDamageTaken = selfHealth;
      } else {
        opponentDamageTaken = opponentHealth;
      }
    } else if (selfDamageTaken == selfHealth && opponentDamageTaken == opponentHealth) {
      if (selfDamageTaken < opponentDamageTaken) {
        selfDamageTaken = selfHealth - 1;
      } else if (selfDamageTaken == opponentDamageTaken && random3 % 2 == 1) {
        selfDamageTaken = selfHealth - 1;
      } else {
        opponentDamageTaken = opponentHealth - 1;
      }
    }

    if (selfDamageTaken == selfHealth && opponentDamageTaken == opponentHealth) revert BothDead();
    if (selfDamageTaken != selfHealth && opponentDamageTaken != opponentHealth) revert BothAlive();

    return (selfDamageTaken, opponentDamageTaken);
  }

  function calculateDamageProbabilities(
    uint32 damageDelta,
    bool isDeltaRightShift
  ) private pure returns (uint32[] memory) {
    uint32[] memory probabilities = new uint32[](4);

    if (isDeltaRightShift) {
      probabilities[0] = 25 + damageDelta;
      probabilities[1] = 50 + damageDelta * 2;
      probabilities[2] = 75 + damageDelta;
      probabilities[3] = 100;
    } else {
      probabilities[0] = 25 - damageDelta;
      probabilities[1] = 50 - damageDelta * 2;
      probabilities[2] = 75 - damageDelta * 3;
      probabilities[3] = 100;
    }

    return probabilities;
  }

  function adjustDamageNumerator(
    uint32 damageNumerator,
    uint32 damageDenominator,
    bool isDeltaRightShift,
    uint32 ownHealth,
    uint32 otherHealth
  ) private pure returns (uint32) {
    if (isDeltaRightShift) {
      return damageNumerator + ((damageDenominator - damageNumerator) * ownHealth) / (ownHealth + otherHealth);
    } else {
      return (damageNumerator * otherHealth) / (ownHealth + otherHealth);
    }
  }

  function calculateDamageFactors(
    uint32 ownHealth,
    uint32 enemyHealth,
    uint32 ownProtection,
    uint32 enemyAttack
  ) private pure returns (bool isDeltaRightShift, uint32 damageNumerator, uint32 damageDenominator) {
    if (ownHealth * 3 <= enemyHealth) {
      return (false, 100, 100);
    } else if (
      ownProtection * 2 <= enemyAttack ||
      ownProtection + 2 <= enemyAttack ||
      (ownHealth * 3 <= enemyHealth * 2 || ownHealth + 5 <= enemyHealth)
    ) {
      return (false, 90, 100);
    } else {
      if (enemyAttack > ownProtection) {
        damageNumerator = enemyAttack - ownProtection;
        isDeltaRightShift = false;
      } else {
        damageNumerator = ownProtection - enemyAttack;
        isDeltaRightShift = true;
      }
      damageDenominator = ownProtection;
      return (isDeltaRightShift, damageNumerator, damageDenominator);
    }
  }
}
