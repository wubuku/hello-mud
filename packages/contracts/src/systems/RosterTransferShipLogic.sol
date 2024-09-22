// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipTransferred } from "./RosterEvents.sol";
import { RosterData, ShipData, Roster, Ship } from "../codegen/index.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";
import { RosterSequenceNumber } from "./RosterSequenceNumber.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { RosterId } from "./RosterId.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { ShipUtil } from "../utils/ShipUtil.sol";

error EmptyShipIdsInSourceRoster(uint256 shipId, uint256 rosterPlayerId, uint32 rosterSequenceNumber);
error RostersTooFarAway(
  uint256 rosterPlayerId,
  uint32 rosterSequenceNumber,
  uint256 toRosterPlayerId,
  uint32 toRosterSequenceNumber
);
error RosterInBattle(uint256 rosterPlayerId, uint32 rosterSequenceNumber, uint256 battleId);
error ToRosterInBattle(uint256 toRosterPlayerId, uint32 toRosterSequenceNumber, uint256 battleId);
error RosterNotExists(uint256 rosterPlayerId, uint32 rosterSequenceNumber);
error ShipNotInRoster(uint256 shipId);

library RosterTransferShipLogic {
  using RosterDataInstance for RosterData;

  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    uint256 toRosterPlayerId,
    uint32 toRosterSequenceNumber,
    uint64 toPosition,
    RosterData memory rosterData
  ) internal view returns (RosterShipTransferred memory) {
    PlayerUtil.assertSenderIsPlayerOwner(playerId);
    //RosterUtil.assertPlayerIsRosterOwner(playerId, RosterId(playerId, sequenceNumber));
    //RosterUtil.assertPlayerIsRosterOwner(playerId, RosterId(toRosterPlayerId, toRosterSequenceNumber));
    if (!ShipIdUtil.containsShipId(rosterData.shipIds, shipId)) {
      revert ShipNotInRoster(shipId);
    }

    RosterData memory toRoster = Roster.get(toRosterPlayerId, toRosterSequenceNumber);
    uint64 currentTimestamp = uint64(block.timestamp);
    if (!rosterData.areRostersCloseEnoughToTransfer(toRoster)) {
      revert RostersTooFarAway(playerId, sequenceNumber, toRosterPlayerId, toRosterSequenceNumber);
    }

    if (toRosterSequenceNumber != RosterSequenceNumber.UNASSIGNED_SHIPS) {
      toRoster.assertRosterShipsNotFull();
    }

    if (rosterData.shipBattleId != 0) {
      revert RosterInBattle(playerId, sequenceNumber, rosterData.shipBattleId);
    }
    if (toRoster.shipBattleId != 0) {
      revert ToRosterInBattle(toRosterPlayerId, toRosterSequenceNumber, toRoster.shipBattleId);
    }

    return
      RosterShipTransferred({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        shipId: shipId,
        toRosterPlayerId: toRosterPlayerId,
        toRosterSequenceNumber: toRosterSequenceNumber,
        toPosition: toPosition,
        transferredAt: currentTimestamp
      });
  }

  function mutate(
    RosterShipTransferred memory rosterShipTransferred,
    RosterData memory rosterData
  ) internal returns (RosterData memory) {
    RosterData memory toRoster = Roster.get(
      rosterShipTransferred.toRosterPlayerId,
      rosterShipTransferred.toRosterSequenceNumber
    );
    if (toRoster.status == uint8(0)) {
      revert RosterNotExists(rosterShipTransferred.toRosterPlayerId, rosterShipTransferred.toRosterSequenceNumber);
    }
    uint256 shipId = rosterShipTransferred.shipId;
    uint256 playerId = rosterShipTransferred.playerId;
    uint32 sequenceNumber = rosterShipTransferred.sequenceNumber;
    ShipData memory shipData = Ship.get(shipId);

    ShipUtil.assertShipOwnership(shipData, shipId, playerId, sequenceNumber);

    uint64 toPosition = rosterShipTransferred.toPosition;
    uint64 transferredAt = rosterShipTransferred.transferredAt;

    if (rosterData.shipIds.length == 0) {
      revert EmptyShipIdsInSourceRoster(shipId, playerId, sequenceNumber);
    }
    rosterData.shipIds = ShipIdUtil.removeShipId(rosterData.shipIds, shipId);
    rosterData.speed = rosterData.calculateRosterSpeed();
    rosterData.coordinatesUpdatedAt = transferredAt; // Update the coordinatesUpdatedAt timestamp here?

    //
    // Note: The consistency of the two-way relationship between Roster and Ship is maintained here.
    //
    toRoster.shipIds = ShipIdUtil.addShipId(toRoster.shipIds, shipId, toPosition);
    toRoster.speed = toRoster.calculateRosterSpeed();
    toRoster.coordinatesUpdatedAt = transferredAt; // Update the coordinatesUpdatedAt timestamp here?
    Roster.set(rosterShipTransferred.toRosterPlayerId, rosterShipTransferred.toRosterSequenceNumber, toRoster);

    shipData.playerId = rosterShipTransferred.toRosterPlayerId;
    shipData.rosterSequenceNumber = rosterShipTransferred.toRosterSequenceNumber;
    Ship.set(shipId, shipData);

    return rosterData;
  }
}
