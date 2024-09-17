// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ShipBattleData, RosterData, ShipData, Ship } from "../codegen/index.sol";
import "../systems/RosterId.sol";
import "./DirectRouteUtil.sol";
import "./SortedVectorUtil.sol";
import "./TsRandomUtil.sol";

library ShipBattleUtil {
  error InitiatorBattleIdMismatch();
  error ResponderBattleIdMismatch();
  error InitiatorIdMismatch();
  error ResponderIdMismatch();
  error ShipNotFoundById();
  error NoLivingShips();
  error RoundMoverNotSet();
  error InvalidSide();
  error PlayerIsNotRosterOwner();

  uint256 constant MIN_DISTANCE_TO_BATTLE = 1000;

  uint8 constant INITIATOR = 1;
  uint8 constant RESPONDER = 0;

  function oppositeSide(uint8 side) internal pure returns (uint8) {
    if (side == INITIATOR) {
      return RESPONDER;
    } else if (side == RESPONDER) {
      return INITIATOR;
    } else {
      revert InvalidSide();
    }
  }

  function assertIdsAreConsistentAndPlayerIsCurrentRoundMover(
    uint256 playerId,
    uint256 shipBattleId,
    ShipBattleData memory shipBattle,
    RosterId memory initiatorId,
    RosterData memory initiator,
    RosterId memory responderId,
    RosterData memory responder
  ) internal pure {
    assertIdsAreConsistent(shipBattleId, shipBattle, initiatorId, initiator, responderId, responder);
    assertPlayerIsCurrentRoundMover(playerId, shipBattle, initiatorId, responderId);
  }

  function assertPlayerIsCurrentRoundMover(
    uint256 playerId,
    ShipBattleData memory shipBattle,
    RosterId memory initiatorId,
    RosterId memory responderId
  ) internal pure {
    uint8 roundMover = shipBattle.roundMover;
    if (roundMover == 0) revert RoundMoverNotSet();
    if (roundMover == INITIATOR) {
      assertPlayerIsRosterOwner(playerId, initiatorId);
    } else {
      assertPlayerIsRosterOwner(playerId, responderId);
    }
  }

  function assertPlayerIsRosterOwner(uint256 playerId, RosterId memory rosterId) internal pure {
    if (playerId != rosterId.playerId) revert PlayerIsNotRosterOwner();
  }

  function assertIdsAreConsistent(
    uint256 shipBattleId,
    ShipBattleData memory shipBattle,
    RosterId memory initiatorId,
    RosterData memory initiator,
    RosterId memory responderId,
    RosterData memory responder
  ) internal pure {
    if (shipBattleId != initiator.shipBattleId) revert InitiatorBattleIdMismatch();
    if (shipBattleId != responder.shipBattleId) revert ResponderBattleIdMismatch();
    if (
      shipBattle.initiatorRosterPlayerId != initiatorId.playerId ||
      shipBattle.initiatorRosterSequenceNumber != initiatorId.sequenceNumber
    ) revert InitiatorIdMismatch();
    if (
      shipBattle.initiatorRosterPlayerId != responderId.playerId ||
      shipBattle.initiatorRosterSequenceNumber != responderId.sequenceNumber
    ) revert ResponderIdMismatch();
  }

  function areRostersCloseEnough(RosterData memory roster1, RosterData memory roster2) internal pure returns (bool) {
    (uint32 x1, uint32 y1) = (roster1.updatedCoordinatesX, roster1.updatedCoordinatesY);
    (uint32 x2, uint32 y2) = (roster2.updatedCoordinatesX, roster2.updatedCoordinatesY);
    uint256 distance = DirectRouteUtil.getDistance(x1, y1, x2, y2);
    return distance <= MIN_DISTANCE_TO_BATTLE;
  }

  function determineAttackerAndDefender(
    uint256 playerId1,
    uint256 playerId2,
    RosterData memory roster1,
    RosterData memory roster2,
    uint32 salt
  ) internal view returns (uint256 attackerShipId, uint256 defenderShipId, uint8 rosterIndicator) {
    (attackerShipId, rosterIndicator) = determineShipToGoFirst(playerId1, playerId2, roster1, roster2, salt);
    if (rosterIndicator == 1) {
      defenderShipId = getFrontShip(roster2);
    } else {
      defenderShipId = getFrontShip(roster1);
    }
    if (defenderShipId == 0) revert NoLivingShips();
  }

  function determineShipToGoFirst(
    uint256 playerId1,
    uint256 playerId2,
    RosterData memory roster1,
    RosterData memory roster2,
    uint32 salt
  ) internal view returns (uint256 shipId, uint8 rosterIndicator) {
    uint256[] memory playerIds = new uint256[](2);
    playerIds[0] = playerId1;
    playerIds[1] = playerId2;
    bytes memory seed1 = SortedVectorUtil.concatIdsBytes(playerIds);
    seed1 = abi.encodePacked(seed1, uint8(salt % 256));
    uint32[8] memory randomInts = TsRandomUtil.get8U32Vector(seed1);

    (uint256 candidate1, uint32 initiative1) = getCandidateAttackerShipId(roster1, randomInts);

    for (uint256 i = 0; i < randomInts.length / 2; i++) {
      (randomInts[i], randomInts[randomInts.length - 1 - i]) = (randomInts[randomInts.length - 1 - i], randomInts[i]);
    }
    (uint256 candidate2, uint32 initiative2) = getCandidateAttackerShipId(roster2, randomInts);

    if (candidate1 == 0 && candidate2 == 0) revert NoLivingShips();
    if (candidate1 == 0) return (candidate2, 2);
    if (candidate2 == 0) return (candidate1, 1);
    if (initiative1 >= initiative2) return (candidate1, 1);
    return (candidate2, 2);
  }

  function getCandidateAttackerShipId(
    RosterData memory roster,
    uint32[8] memory randomInts
  ) internal view returns (uint256 candidateId, uint32 maxInitiative) {
    uint256[] memory shipIds = roster.shipIds;
    maxInitiative = 0;
    candidateId = 0;

    for (uint256 i = 0; i < shipIds.length; i++) {
      uint256 shipId = shipIds[i];
      ShipData memory shipData = Ship.get(shipId);
      uint32 health = shipData.healthPoints;
      uint32 speed = shipData.speed;

      if (health > 0) {
        uint32 initiative = 1 + (randomInts[i % randomInts.length] % 8) + speed;
        if (initiative > maxInitiative) {
          maxInitiative = initiative;
          candidateId = shipId;
        }
      }
    }

    return (candidateId, maxInitiative);
  }

  function getFrontShip(RosterData memory roster) internal view returns (uint256) {
    uint256[] memory shipIds = roster.shipIds;
    for (uint256 i = 0; i < shipIds.length; i++) {
      uint256 shipId = shipIds[i];

      if (Ship.getHealthPoints(shipId) > 0) {
        return shipId;
      }
    }
    return 0;
  }
}
