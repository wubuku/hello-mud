// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { ShipBattle, ShipBattleData, ShipBattleIdGenerator } from "../codegen/index.sol";
import { ShipBattleInitiated, ShipBattleMoveMade, ShipBattleLootTaken } from "./ShipBattleEvents.sol";
import { ShipBattleInitiateBattleLogic } from "./ShipBattleInitiateBattleLogic.sol";
import { ShipBattleMakeMoveLogic } from "./ShipBattleMakeMoveLogic.sol";
import { ShipBattleTakeLootLogic } from "./ShipBattleTakeLootLogic.sol";

contract ShipBattleSystem is System {
  event ShipBattleInitiatedEvent(uint256 indexed id, uint256 playerId, uint256 initiatorRosterPlayerId, uint32 initiatorRosterSequenceNumber, uint256 responderRosterPlayerId, uint32 responderRosterSequenceNumber, int32 initiatorCoordinatesX, int32 initiatorCoordinatesY, int32 responderCoordinatesX, int32 responderCoordinatesY, uint64 startedAt, uint8 firstRoundMover, uint256 firstRoundAttackerShip, uint256 firstRoundDefenderShip);

  event ShipBattleMoveMadeEvent(uint256 indexed id, uint8 attackerCommand, uint8 defenderCommand, uint32 roundNumber, uint32 defenderDamageTaken, uint32 attackerDamageTaken, bool isBattleEnded, uint8 winner, uint64 nextRoundStartedAt, uint8 nextRoundMover, uint256 nextRoundAttackerShip, uint256 nextRoundDefenderShip);

  event ShipBattleLootTakenEvent(uint256 indexed id, uint8 choice, uint64 lootedAt, uint32 increasedExperience, uint16 newLevel, uint32 loserIncreasedExperience, uint16 loserNewLevel);

  function shipBattleInitiateBattle(uint256 playerId, uint256 initiatorRosterPlayerId, uint32 initiatorRosterSequenceNumber, uint256 responderRosterPlayerId, uint32 responderRosterSequenceNumber, int32 initiatorCoordinatesX, int32 initiatorCoordinatesY, int32 responderCoordinatesX, int32 responderCoordinatesY) public returns (uint256) {
    uint256 id = ShipBattleIdGenerator.get() + 1;
    ShipBattleIdGenerator.set(id);
    ShipBattleData memory shipBattleData = ShipBattle.get(id);
    require(
      shipBattleData.initiatorRosterPlayerId == uint256(0) && shipBattleData.initiatorRosterSequenceNumber == uint32(0) && shipBattleData.responderRosterPlayerId == uint256(0) && shipBattleData.responderRosterSequenceNumber == uint32(0) && shipBattleData.status == uint8(0) && shipBattleData.endedAt == uint64(0),
      "ShipBattle already exists"
    );
    ShipBattleInitiated memory shipBattleInitiated = ShipBattleInitiateBattleLogic.verify(id, playerId, initiatorRosterPlayerId, initiatorRosterSequenceNumber, responderRosterPlayerId, responderRosterSequenceNumber, initiatorCoordinatesX, initiatorCoordinatesY, responderCoordinatesX, responderCoordinatesY);
    shipBattleInitiated.id = id;
    emit ShipBattleInitiatedEvent(shipBattleInitiated.id, shipBattleInitiated.playerId, shipBattleInitiated.initiatorRosterPlayerId, shipBattleInitiated.initiatorRosterSequenceNumber, shipBattleInitiated.responderRosterPlayerId, shipBattleInitiated.responderRosterSequenceNumber, shipBattleInitiated.initiatorCoordinatesX, shipBattleInitiated.initiatorCoordinatesY, shipBattleInitiated.responderCoordinatesX, shipBattleInitiated.responderCoordinatesY, shipBattleInitiated.startedAt, shipBattleInitiated.firstRoundMover, shipBattleInitiated.firstRoundAttackerShip, shipBattleInitiated.firstRoundDefenderShip);
    ShipBattleData memory newShipBattleData = ShipBattleInitiateBattleLogic.mutate(shipBattleInitiated);
    ShipBattle.set(id, newShipBattleData);
    return id;
  }

  function shipBattleMakeMove(uint256 id, uint8 attackerCommand) public {
    ShipBattleData memory shipBattleData = ShipBattle.get(id);
    require(
      !(shipBattleData.initiatorRosterPlayerId == uint256(0) && shipBattleData.initiatorRosterSequenceNumber == uint32(0) && shipBattleData.responderRosterPlayerId == uint256(0) && shipBattleData.responderRosterSequenceNumber == uint32(0) && shipBattleData.status == uint8(0) && shipBattleData.endedAt == uint64(0)),
      "ShipBattle does not exist"
    );
    ShipBattleMoveMade memory shipBattleMoveMade = ShipBattleMakeMoveLogic.verify(id, attackerCommand, shipBattleData);
    shipBattleMoveMade.id = id;
    emit ShipBattleMoveMadeEvent(shipBattleMoveMade.id, shipBattleMoveMade.attackerCommand, shipBattleMoveMade.defenderCommand, shipBattleMoveMade.roundNumber, shipBattleMoveMade.defenderDamageTaken, shipBattleMoveMade.attackerDamageTaken, shipBattleMoveMade.isBattleEnded, shipBattleMoveMade.winner, shipBattleMoveMade.nextRoundStartedAt, shipBattleMoveMade.nextRoundMover, shipBattleMoveMade.nextRoundAttackerShip, shipBattleMoveMade.nextRoundDefenderShip);
    ShipBattleData memory updatedShipBattleData = ShipBattleMakeMoveLogic.mutate(shipBattleMoveMade, shipBattleData);
    ShipBattle.set(id, updatedShipBattleData);
  }

  function shipBattleTakeLoot(uint256 id, uint8 choice) public {
    ShipBattleData memory shipBattleData = ShipBattle.get(id);
    require(
      !(shipBattleData.initiatorRosterPlayerId == uint256(0) && shipBattleData.initiatorRosterSequenceNumber == uint32(0) && shipBattleData.responderRosterPlayerId == uint256(0) && shipBattleData.responderRosterSequenceNumber == uint32(0) && shipBattleData.status == uint8(0) && shipBattleData.endedAt == uint64(0)),
      "ShipBattle does not exist"
    );
    ShipBattleLootTaken memory shipBattleLootTaken = ShipBattleTakeLootLogic.verify(id, choice, shipBattleData);
    shipBattleLootTaken.id = id;
    emit ShipBattleLootTakenEvent(shipBattleLootTaken.id, shipBattleLootTaken.choice, shipBattleLootTaken.lootedAt, shipBattleLootTaken.increasedExperience, shipBattleLootTaken.newLevel, shipBattleLootTaken.loserIncreasedExperience, shipBattleLootTaken.loserNewLevel);
    ShipBattleData memory updatedShipBattleData = ShipBattleTakeLootLogic.mutate(shipBattleLootTaken, shipBattleData);
    ShipBattle.set(id, updatedShipBattleData);
  }

}
