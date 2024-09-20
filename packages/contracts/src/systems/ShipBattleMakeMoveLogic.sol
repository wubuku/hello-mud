// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipBattleMoveMade } from "./ShipBattleEvents.sol";
import { RosterStatus } from "./RosterStatus.sol";
import { BattleStatus } from "./BattleStatus.sol";
import { PlayerData, RosterData, Roster, ShipData, Ship, ShipBattleData } from "../codegen/index.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { ShipBattleUtil } from "../utils/ShipBattleUtil.sol";
import { ShipUtil } from "../utils/ShipUtil.sol";
import { FightToDeath } from "../utils/FightToDeath.sol";
import { RosterId } from "../systems/RosterId.sol";
import { SortedVectorUtil } from "../utils/SortedVectorUtil.sol";
import { ItemIdQuantityPair } from "../systems/ItemIdQuantityPair.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";

library ShipBattleMakeMoveLogic {
  using RosterDataInstance for RosterData;

  error RoundMoverNotSet();
  error AttackerShipNotSet();
  error DefenderShipNotSet();
  error WinnerNotSet();
  error WinnerSetButBattleNotEnded();
  error InvalidWinner();

  uint32 constant PLAYER_SHIP_EXPERIENCE = 8;

  function verify(
    uint256 id,
    uint8 attackerCommand,
    ShipBattleData memory shipBattleData
  ) internal view returns (ShipBattleMoveMade memory) {
    RosterId memory initiatorId = RosterId(
      shipBattleData.initiatorRosterPlayerId,
      shipBattleData.initiatorRosterSequenceNumber
    );
    RosterId memory responderId = RosterId(
      shipBattleData.responderRosterPlayerId,
      shipBattleData.responderRosterSequenceNumber
    );
    RosterData memory initiator = Roster.get(
      shipBattleData.initiatorRosterPlayerId,
      shipBattleData.initiatorRosterSequenceNumber
    );
    RosterData memory responder = Roster.get(
      shipBattleData.responderRosterPlayerId,
      shipBattleData.responderRosterSequenceNumber
    );

    ShipBattleUtil.assertIdsAreConsistent(id, shipBattleData, initiatorId, initiator, responderId, responder);

    uint8 defenderCommand = 1; // Assuming attack is always 1
    uint64 nowTime = uint64(block.timestamp);
    uint32 currentRoundNumber = shipBattleData.roundNumber;

    if (shipBattleData.roundAttackerShip == 0) revert AttackerShipNotSet();
    if (shipBattleData.roundDefenderShip == 0) revert DefenderShipNotSet();
    if (shipBattleData.roundMover == 0) revert RoundMoverNotSet();

    ShipData memory attackerShip = Ship.get(shipBattleData.roundAttackerShip);
    ShipData memory defenderShip = Ship.get(shipBattleData.roundDefenderShip);

    bytes memory seed1 = abi.encodePacked(id, currentRoundNumber % 256);

    uint32 attackerShipHp = attackerShip.healthPoints;
    uint32 defenderShipHp = defenderShip.healthPoints;

    FightToDeath.FightToDeathParams memory params;
    params.seed = seed1;
    params.selfAttack = attackerShip.attack;
    params.selfProtection = defenderShip.protection;
    params.selfHealth = attackerShipHp;
    params.opponentAttack = defenderShip.attack;
    params.opponentProtection = defenderShip.protection;
    params.opponentHealth = defenderShipHp;

    (uint32 attackerDamageTaken, uint32 defenderDamageTaken) = FightToDeath.perform(params);

    if (defenderDamageTaken >= defenderShipHp) {
      defenderDamageTaken = defenderShipHp;
      defenderShipHp = 0;
    } else {
      defenderShipHp -= defenderDamageTaken;
    }

    bool isBattleEnded = false;
    uint8 winner = 0;

    RosterData memory attackerRoster = shipBattleData.roundMover == ShipBattleUtil.INITIATOR ? initiator : responder;
    RosterData memory defenderRoster = shipBattleData.roundMover == ShipBattleUtil.INITIATOR ? responder : initiator;

    if (defenderShipHp == 0 && defenderRoster.isDestroyedExceptShip(shipBattleData.roundDefenderShip)) {
      isBattleEnded = true;
      winner = shipBattleData.roundMover;
    }

    if (attackerDamageTaken > 0) {
      if (attackerDamageTaken >= attackerShipHp) {
        attackerDamageTaken = attackerShipHp;
        attackerShipHp = 0;
      } else {
        attackerShipHp -= attackerDamageTaken;
      }

      if (attackerShipHp == 0 && attackerRoster.isDestroyedExceptShip(shipBattleData.roundAttackerShip)) {
        isBattleEnded = true;
        winner = ShipBattleUtil.oppositeSide(shipBattleData.roundMover);
      }
    }

    uint8 nextRoundMover = 0;
    uint256 nextRoundAttackerShip = 0;
    uint256 nextRoundDefenderShip = 0;
    uint64 nextRoundStartedAt = nowTime;
    uint8 rosterIndicator = 0;

    if (!isBattleEnded) {
      uint32 nextRoundNumber = currentRoundNumber + 1;
      (nextRoundAttackerShip, nextRoundDefenderShip, rosterIndicator) = ShipBattleUtil.determineAttackerAndDefender(
        initiatorId.playerId,
        responderId.playerId,
        initiator,
        responder,
        nextRoundNumber
      );
      nextRoundMover = rosterIndicator == 1 ? ShipBattleUtil.INITIATOR : ShipBattleUtil.RESPONDER;
    }

    ShipBattleMoveMade memory _event;
    _event.id = id;
    _event.attackerCommand = attackerCommand;
    _event.defenderCommand = defenderCommand;
    _event.roundNumber = currentRoundNumber;
    _event.defenderDamageTaken = defenderDamageTaken;
    _event.attackerDamageTaken = attackerDamageTaken;
    _event.isBattleEnded = isBattleEnded;
    _event.winner = winner;
    _event.nextRoundStartedAt = nextRoundStartedAt;
    _event.nextRoundMover = nextRoundMover;
    _event.nextRoundAttackerShip = nextRoundAttackerShip;
    _event.nextRoundDefenderShip = nextRoundDefenderShip;

    return _event;
  }

  function mutate(
    ShipBattleMoveMade memory shipBattleMoveMade,
    ShipBattleData memory shipBattleData
  ) internal returns (ShipBattleData memory) {
    if (shipBattleMoveMade.isBattleEnded) {
      shipBattleData.status = uint8(BattleStatus.ENDED);
      shipBattleData.endedAt = shipBattleMoveMade.nextRoundStartedAt;
      if (shipBattleMoveMade.winner == 0) revert WinnerNotSet();
      shipBattleData.winner = shipBattleMoveMade.winner;
    } else {
      shipBattleData.roundNumber++;
      if (shipBattleMoveMade.winner != 0) revert WinnerSetButBattleNotEnded();
    }

    shipBattleData.roundMover = shipBattleMoveMade.nextRoundMover;
    shipBattleData.roundAttackerShip = shipBattleMoveMade.nextRoundAttackerShip;
    shipBattleData.roundDefenderShip = shipBattleMoveMade.nextRoundDefenderShip;
    shipBattleData.roundStartedAt = shipBattleMoveMade.nextRoundStartedAt;

    updateShipHealthPoints(shipBattleData, shipBattleMoveMade);
    updateExperiencePoints(shipBattleData, shipBattleMoveMade);

    if (shipBattleMoveMade.isBattleEnded) {
      updateRosterStatus(shipBattleData, shipBattleMoveMade.winner);
    }

    return shipBattleData;
  }

  function updateShipHealthPoints(
    ShipBattleData memory shipBattleData,
    ShipBattleMoveMade memory shipBattleMoveMade
  ) internal {
    uint256 attackerShipId = shipBattleData.roundAttackerShip;
    uint256 defenderShipId = shipBattleData.roundDefenderShip;
    ShipData memory attackerShip = Ship.get(attackerShipId);
    ShipData memory defenderShip = Ship.get(defenderShipId);

    attackerShip.healthPoints = attackerShip.healthPoints > shipBattleMoveMade.attackerDamageTaken
      ? attackerShip.healthPoints - shipBattleMoveMade.attackerDamageTaken
      : 0;
    defenderShip.healthPoints = defenderShip.healthPoints > shipBattleMoveMade.defenderDamageTaken
      ? defenderShip.healthPoints - shipBattleMoveMade.defenderDamageTaken
      : 0;

    Ship.set(attackerShipId, attackerShip);
    Ship.set(defenderShipId, defenderShip);
  }

  function updateExperiencePoints(
    ShipBattleData memory shipBattleData,
    ShipBattleMoveMade memory shipBattleMoveMade
  ) internal view {
    ShipData memory attackerShip = Ship.get(shipBattleData.roundAttackerShip);
    ShipData memory defenderShip = Ship.get(shipBattleData.roundDefenderShip);

    uint32 attackerXpGained = 0;
    uint32 defenderXpGained = 0;

    if (defenderShip.healthPoints == 0 && shipBattleMoveMade.defenderDamageTaken > 0) {
      attackerXpGained = calculateShipExperience(defenderShip);
    }

    if (attackerShip.healthPoints == 0 && shipBattleMoveMade.attackerDamageTaken > 0) {
      defenderXpGained = calculateShipExperience(attackerShip);
    }

    if (shipBattleData.roundMover == ShipBattleUtil.INITIATOR) {
      if (attackerXpGained > 0) {
        shipBattleData.initiatorExperiences = appendToArray(shipBattleData.initiatorExperiences, attackerXpGained);
      }
      if (defenderXpGained > 0) {
        shipBattleData.responderExperiences = appendToArray(shipBattleData.responderExperiences, defenderXpGained);
      }
    } else {
      if (attackerXpGained > 0) {
        shipBattleData.responderExperiences = appendToArray(shipBattleData.responderExperiences, attackerXpGained);
      }
      if (defenderXpGained > 0) {
        shipBattleData.initiatorExperiences = appendToArray(shipBattleData.initiatorExperiences, defenderXpGained);
      }
    }
  }

  function updateRosterStatus(ShipBattleData memory shipBattleData, uint8 winner) internal {
    RosterId memory loserRosterId;
    if (winner == ShipBattleUtil.INITIATOR) {
      loserRosterId = RosterId(shipBattleData.responderRosterPlayerId, shipBattleData.responderRosterSequenceNumber);
    } else if (winner == ShipBattleUtil.RESPONDER) {
      loserRosterId = RosterId(shipBattleData.initiatorRosterPlayerId, shipBattleData.initiatorRosterSequenceNumber);
    } else {
      revert InvalidWinner();
    }

    RosterData memory loserRoster = Roster.get(loserRosterId.playerId, loserRosterId.sequenceNumber);
    loserRoster.status = uint8(RosterStatus.DESTROYED);
    Roster.set(loserRosterId.playerId, loserRosterId.sequenceNumber, loserRoster);
  }

  function calculateShipExperience(ShipData memory ship) internal pure returns (uint32) {
    ItemIdQuantityPair[] memory buildingExpenses = SortedVectorUtil.newItemIdQuantityPairs(
      ship.buildingExpensesItemIds,
      ship.buildingExpensesQuantities
    );
    return ShipUtil.calculateEnvironmentShipExperience(buildingExpenses);
  }

  function appendToArray(uint32[] memory arr, uint32 value) internal pure returns (uint32[] memory) {
    uint32[] memory newArr = new uint32[](arr.length + 1);
    for (uint i = 0; i < arr.length; i++) {
      newArr[i] = arr[i];
    }
    newArr[arr.length] = value;
    return newArr;
  }
}
