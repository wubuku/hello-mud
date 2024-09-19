// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipTransferred } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";

error ShipNotFoundInSourceRoster(uint256 shipId, uint256 rosterId);
error RostersTooFarAway(uint256 fromRosterId, uint256 toRosterId);
error RosterInBattle(uint256 rosterId, uint256 battleId);
error ToRosterInBattle(uint256 toRosterId, uint256 battleId);
error RosterShipsFull(uint256 rosterId, uint32 currentShipCount, uint32 maxShipCount);

library RosterTransferShipLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    uint256 toRosterPlayerId,
    uint32 toRosterSequenceNumber,
    uint64 toPosition,
    RosterData memory rosterData
  ) internal pure returns (RosterShipTransferred memory) {
    // TODO: Get or create these variables
    RosterData memory toRoster;
    uint64 currentTimestamp;

    // TODO: Implement permission checks
    // TODO: Check if rosters are close enough
    // if (!areRostersCloseEnoughToTransfer(rosterData, toRoster)) {
    //   revert RostersTooFarAway(rosterData.id, toRoster.id);
    // }

    // TODO: Check if destination roster is full (if not UNASSIGNED_SHIPS)
    // if (toRosterSequenceNumber != UNASSIGNED_SHIPS) {
    //   (bool isFull, uint32 currentCount, uint32 maxCount) = isRosterShipsFull(toRoster);
    //   if (isFull) {
    //     revert RosterShipsFull(toRoster.id, currentCount, maxCount);
    //   }
    // }

    // TODO: Check if rosters are in battle
    // if (rosterData.shipBattleId != 0) {
    //   revert RosterInBattle(rosterData.id, rosterData.shipBattleId);
    // }
    // if (toRoster.shipBattleId != 0) {
    //   revert ToRosterInBattle(toRoster.id, toRoster.shipBattleId);
    // }

    // TODO: Add more checks if needed

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
  ) internal pure returns (RosterData memory) {
    // TODO: Get or create these variables
    RosterData memory toRoster;
    uint256 shipId = rosterShipTransferred.shipId;
    uint64 toPosition = rosterShipTransferred.toPosition;
    uint64 transferredAt = rosterShipTransferred.transferredAt;

    // TODO: Remove ship from source roster
    // bool shipRemoved = removeShipId(rosterData.shipIds, shipId);
    // if (!shipRemoved) {
    //   revert ShipNotFoundInSourceRoster(shipId, rosterData.id);
    // }

    // TODO: Get ship data
    // ShipData memory ship = removeShip(rosterData.ships, shipId);

    // TODO: Recalculate speed for source roster
    // uint32 fromSpeed = calculateRosterSpeed(rosterData);
    // rosterData.speed = fromSpeed;

    // TODO: Add ship to destination roster
    // if (toPosition != type(uint64).max) {
    //   insertShipId(toRoster.shipIds, shipId, toPosition);
    // } else {
    //   toRoster.shipIds.push(shipId);
    // }
    // addShip(toRoster.ships, shipId, ship);

    // TODO: Recalculate speed for destination roster
    // uint32 toSpeed = calculateRosterSpeed(toRoster);
    // toRoster.speed = toSpeed;

    // Update coordinates updated timestamp for both rosters
    rosterData.coordinatesUpdatedAt = transferredAt;
    // toRoster.coordinatesUpdatedAt = transferredAt;

    // TODO: Update toRoster data

    return rosterData;
  }
}
