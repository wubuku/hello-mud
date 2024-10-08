// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ShipBattleLocationParams } from "./ShipBattleLocationParams.sol";

import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

struct ShipBattleInitiated {
  uint256 id;
  uint256 playerId;
  /**
   * @dev The PlayerId of the InitiatorRoster.
   */
  uint256 initiatorRosterPlayerId;
  /**
   * @dev The SequenceNumber of the InitiatorRoster.
   */
  uint32 initiatorRosterSequenceNumber;
  /**
   * @dev The PlayerId of the ResponderRoster.
   */
  uint256 responderRosterPlayerId;
  /**
   * @dev The SequenceNumber of the ResponderRoster.
   */
  uint32 responderRosterSequenceNumber;
  ShipBattleLocationParams updateLocationParams;
  uint64 startedAt;
  uint8 firstRoundMover;
  uint256 firstRoundAttackerShip;
  uint256 firstRoundDefenderShip;
}

struct ShipBattleMoveMade {
  uint256 id;
  uint8 attackerCommand;
  uint8 defenderCommand;
  uint32 roundNumber;
  uint32 defenderDamageTaken;
  uint32 attackerDamageTaken;
  bool isBattleEnded;
  uint8 winner;
  uint64 nextRoundStartedAt;
  uint8 nextRoundMover;
  uint256 nextRoundAttackerShip;
  uint256 nextRoundDefenderShip;
}

struct ShipBattleLootTaken {
  uint256 id;
  /**
   * @dev 1: Take all, 2: Leave it
   */
  uint8 choice;
  ItemIdQuantityPair[] loot;
  /**
   * @dev The time when the loot is taken
   */
  uint64 lootedAt;
  uint32 increasedExperience;
  uint16 newLevel;
  uint32 loserIncreasedExperience;
  uint16 loserNewLevel;
}

