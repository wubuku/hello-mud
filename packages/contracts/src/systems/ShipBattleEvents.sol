// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

struct ShipBattleInitiated {
  uint256 id;
  uint256 playerId;
  uint256 initiatorRosterPlayerId;
  uint32 initiatorRosterSequenceNumber;
  uint256 responderRosterPlayerId;
  uint32 responderRosterSequenceNumber;
  int32 initiatorCoordinatesX;
  int32 initiatorCoordinatesY;
  int32 responderCoordinatesX;
  int32 responderCoordinatesY;
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
  uint8 choice;
  uint64 lootedAt;
  uint32 increasedExperience;
  uint16 newLevel;
  uint32 loserIncreasedExperience;
  uint16 loserNewLevel;
}

