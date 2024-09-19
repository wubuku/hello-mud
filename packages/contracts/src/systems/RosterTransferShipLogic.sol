// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipTransferred } from "./RosterEvents.sol";
import { RosterData, ShipData, Roster, Ship } from "../codegen/index.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";
import { RosterSequenceNumber } from "./RosterSequenceNumber.sol";

error ShipNotFoundInSourceRoster(uint256 shipId, uint256 rosterPlayerId, uint32 rosterSequenceNumber);
error RostersTooFarAway(
  uint256 rosterPlayerId,
  uint32 rosterSequenceNumber,
  uint256 toRosterPlayerId,
  uint32 toRosterSequenceNumber
);
error RosterInBattle(uint256 rosterPlayerId, uint32 rosterSequenceNumber, uint256 battleId);
error ToRosterInBattle(uint256 toRosterPlayerId, uint32 toRosterSequenceNumber, uint256 battleId);

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
    uint256 shipId = rosterShipTransferred.shipId;
    uint64 toPosition = rosterShipTransferred.toPosition;
    uint64 transferredAt = rosterShipTransferred.transferredAt;

    rosterData.shipIds = ShipIdUtil.removeShipId(rosterData.shipIds, shipId);
    if (rosterData.shipIds.length == 0) {
      revert ShipNotFoundInSourceRoster(shipId, rosterShipTransferred.playerId, rosterShipTransferred.sequenceNumber);
    }
    rosterData.speed = rosterData.calculateRosterSpeed();

    toRoster.shipIds = ShipIdUtil.addShipId(toRoster.shipIds, shipId, toPosition);
    toRoster.speed = toRoster.calculateRosterSpeed();

    rosterData.coordinatesUpdatedAt = transferredAt;
    toRoster.coordinatesUpdatedAt = transferredAt;

    Roster.set(rosterShipTransferred.toRosterPlayerId, rosterShipTransferred.toRosterSequenceNumber, toRoster);

    return rosterData;
  }
}
