// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipBattleInitiated } from "./ShipBattleEvents.sol";
import { RosterStatus } from "./RosterStatus.sol";
import { BattleStatus } from "./BattleStatus.sol";
import { PlayerData, Player, RosterData, Roster, ShipBattleData } from "../codegen/index.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { ShipBattleUtil } from "../utils/ShipBattleUtil.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { RosterId } from "./RosterId.sol";

library ShipBattleInitiateBattleLogic {
  using RosterDataInstance for RosterData;

  error InitiatorNotBattleReady();
  error ResponderNotBattleReady();
  error NotCloseEnoughToBattle();
  error PlayerDoesNotExist(uint256 playerId);

  uint32 constant FIRST_ROUND_NUMBER = 1;

  function verify(
    uint256 id,
    uint256 playerId,
    uint256 initiatorRosterPlayerId,
    uint32 initiatorRosterSequenceNumber,
    uint256 responderRosterPlayerId,
    uint32 responderRosterSequenceNumber,
    uint32 initiatorCoordinatesX,
    uint32 initiatorCoordinatesY,
    uint32 responderCoordinatesX,
    uint32 responderCoordinatesY
  ) internal view returns (ShipBattleInitiated memory) {
    PlayerData memory playerData = Player.get(playerId);
    if (
      playerData.owner == address(0) &&
      playerData.level == uint16(0) &&
      playerData.experience == uint32(0) &&
      playerData.claimedIslandX == uint32(0) &&
      playerData.claimedIslandY == uint32(0) &&
      bytes(playerData.name).length == 0
    ) {
      revert PlayerDoesNotExist(playerId);
    }
    RosterData memory initiator = Roster.get(initiatorRosterPlayerId, initiatorRosterSequenceNumber);
    RosterData memory responder = Roster.get(responderRosterPlayerId, responderRosterSequenceNumber);

    if (!initiator.isStatusBattleReady()) revert InitiatorNotBattleReady();
    if (!responder.isStatusBattleReady()) revert ResponderNotBattleReady();

    PlayerUtil.assertSenderIsPlayerOwner(playerId);
    RosterUtil.assertPlayerIsRosterOwner(playerId, RosterId(initiatorRosterPlayerId, initiatorRosterSequenceNumber));
    RosterUtil.assertRosterIsNotUnassignedShips(initiatorRosterSequenceNumber);
    RosterUtil.assertRosterIsNotUnassignedShips(responderRosterSequenceNumber);

    uint64 currentTimestamp = uint64(block.timestamp);

    // Update the locations of the two rosters
    if (initiator.status == uint8(RosterStatus.UNDERWAY)) {
      (bool updatable, uint64 t, ) = initiator.isCurrentLocationUpdatable(
        currentTimestamp,
        initiatorCoordinatesX,
        initiatorCoordinatesY
      );
      if (updatable) {
        initiator.updatedCoordinatesX = initiatorCoordinatesX;
        initiator.updatedCoordinatesY = initiatorCoordinatesY;
        initiator.coordinatesUpdatedAt = t;
      }
    }

    if (responder.status == uint8(RosterStatus.UNDERWAY)) {
      (bool updatable, uint64 t, ) = responder.isCurrentLocationUpdatable(
        currentTimestamp,
        responderCoordinatesX,
        responderCoordinatesY
      );
      if (updatable) {
        responder.updatedCoordinatesX = responderCoordinatesX;
        responder.updatedCoordinatesY = responderCoordinatesY;
        responder.coordinatesUpdatedAt = t;
      }
    }

    if (!ShipBattleUtil.areRostersCloseEnough(initiator, responder)) revert NotCloseEnoughToBattle();

    (uint256 attackerShipId, uint256 defenderShipId, uint8 rosterIndicator) = ShipBattleUtil
      .determineAttackerAndDefender(
        initiatorRosterPlayerId,
        responderRosterPlayerId,
        initiator,
        responder,
        FIRST_ROUND_NUMBER
      );

    uint8 firstRoundMover = rosterIndicator == 1 ? ShipBattleUtil.INITIATOR : ShipBattleUtil.RESPONDER;

    return
      ShipBattleInitiated({
        id: id,
        playerId: playerId,
        initiatorRosterPlayerId: initiatorRosterPlayerId,
        initiatorRosterSequenceNumber: initiatorRosterSequenceNumber,
        responderRosterPlayerId: responderRosterPlayerId,
        responderRosterSequenceNumber: responderRosterSequenceNumber,
        initiatorCoordinatesX: initiatorCoordinatesX,
        initiatorCoordinatesY: initiatorCoordinatesY,
        responderCoordinatesX: responderCoordinatesX,
        responderCoordinatesY: responderCoordinatesY,
        startedAt: currentTimestamp,
        firstRoundMover: firstRoundMover,
        firstRoundAttackerShip: attackerShipId,
        firstRoundDefenderShip: defenderShipId
      });
  }

  function mutate(ShipBattleInitiated memory shipBattleInitiated) internal returns (ShipBattleData memory) {
    ShipBattleData memory shipBattleData;
    shipBattleData.initiatorRosterPlayerId = shipBattleInitiated.initiatorRosterPlayerId;
    shipBattleData.initiatorRosterSequenceNumber = shipBattleInitiated.initiatorRosterSequenceNumber;
    shipBattleData.responderRosterPlayerId = shipBattleInitiated.responderRosterPlayerId;
    shipBattleData.responderRosterSequenceNumber = shipBattleInitiated.responderRosterSequenceNumber;
    shipBattleData.status = uint8(BattleStatus.IN_PROGRESS);
    shipBattleData.endedAt = 0;
    shipBattleData.winner = 0;
    shipBattleData.roundNumber = FIRST_ROUND_NUMBER;
    shipBattleData.roundStartedAt = shipBattleInitiated.startedAt;
    shipBattleData.roundMover = shipBattleInitiated.firstRoundMover;
    shipBattleData.roundAttackerShip = shipBattleInitiated.firstRoundAttackerShip;
    shipBattleData.roundDefenderShip = shipBattleInitiated.firstRoundDefenderShip;

    uint256 initiatorPlayerId = shipBattleInitiated.initiatorRosterPlayerId;
    uint32 initiatorSequenceNumber = shipBattleInitiated.initiatorRosterSequenceNumber;
    uint256 responderPlayerId = shipBattleInitiated.responderRosterPlayerId;
    uint32 responderSequenceNumber = shipBattleInitiated.responderRosterSequenceNumber;

    RosterData memory initiator = Roster.get(initiatorPlayerId, initiatorSequenceNumber);
    RosterData memory responder = Roster.get(responderPlayerId, responderSequenceNumber);

    uint256 shipBattleId = shipBattleInitiated.id;

    initiator.status = uint8(RosterStatus.IN_BATTLE);
    initiator.shipBattleId = shipBattleId;
    Roster.set(initiatorPlayerId, initiatorSequenceNumber, initiator);
    responder.status = uint8(RosterStatus.IN_BATTLE);
    responder.shipBattleId = shipBattleId;
    Roster.set(responderPlayerId, responderSequenceNumber, responder);

    return shipBattleData;
  }
}
