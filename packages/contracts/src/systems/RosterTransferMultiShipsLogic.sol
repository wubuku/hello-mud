// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterMultiShipsTransferred } from "./RosterEvents.sol";
import { RosterData, ShipData, Roster, Ship } from "../codegen/index.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";
import { RosterSequenceNumber } from "./RosterSequenceNumber.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { ShipUtil } from "../utils/ShipUtil.sol";
import { TwoRostersLocationUpdateParams } from "./TwoRostersLocationUpdateParams.sol";

library RosterTransferMultiShipsLogic {
  error EmptyShipIdsInSourceRoster(uint256 rosterPlayerId, uint32 rosterSequenceNumber);
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
  error NotEnoughSpaceInToRoster(uint256 toRosterPlayerId, uint32 toRosterSequenceNumber);

  using RosterDataInstance for RosterData;

  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256[] memory shipIds,
    uint256 toRosterPlayerId,
    uint32 toRosterSequenceNumber,
    uint64 toPosition,
    TwoRostersLocationUpdateParams memory locationUpdateParams,
    RosterData memory rosterData
  ) internal view returns (RosterMultiShipsTransferred memory) {
    PlayerUtil.assertSenderIsPlayerOwner(playerId);

    for (uint256 i = 0; i < shipIds.length; i++) {
      if (!ShipIdUtil.containsShipId(rosterData.shipIds, shipIds[i])) {
        revert ShipNotInRoster(shipIds[i]);
      }
    }

    RosterData memory toRoster = Roster.get(toRosterPlayerId, toRosterSequenceNumber);
    uint64 currentTimestamp = uint64(block.timestamp);
    if (!rosterData.areRostersCloseEnoughToTransfer(toRoster)) {
      revert RostersTooFarAway(playerId, sequenceNumber, toRosterPlayerId, toRosterSequenceNumber);
    }

    if (toRosterSequenceNumber != RosterSequenceNumber.UNASSIGNED_SHIPS) {
      if (toRoster.shipIds.length + shipIds.length > RosterDataInstance.MAX_SHIPS_PER_ROSTER) {
        revert NotEnoughSpaceInToRoster(toRosterPlayerId, toRosterSequenceNumber);
      }
    }

    if (rosterData.shipBattleId != 0) {
      revert RosterInBattle(playerId, sequenceNumber, rosterData.shipBattleId);
    }
    if (toRoster.shipBattleId != 0) {
      revert ToRosterInBattle(toRosterPlayerId, toRosterSequenceNumber, toRoster.shipBattleId);
    }

    return
      RosterMultiShipsTransferred({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        shipIds: shipIds,
        toRosterPlayerId: toRosterPlayerId,
        toRosterSequenceNumber: toRosterSequenceNumber,
        toPosition: toPosition,
        locationUpdateParams: locationUpdateParams,
        transferredAt: currentTimestamp
      });
  }

  function mutate(
    RosterMultiShipsTransferred memory rosterMultiShipsTransferred,
    RosterData memory rosterData
  ) internal returns (RosterData memory) {
    rosterData = Roster.get(rosterShipTransferred.playerId, rosterShipTransferred.sequenceNumber);
    RosterData memory toRoster = Roster.get(
      rosterMultiShipsTransferred.toRosterPlayerId,
      rosterMultiShipsTransferred.toRosterSequenceNumber
    );
    if (toRoster.status == uint8(0)) {
      revert RosterNotExists(
        rosterMultiShipsTransferred.toRosterPlayerId,
        rosterMultiShipsTransferred.toRosterSequenceNumber
      );
    }

    uint256[] memory shipIds = rosterMultiShipsTransferred.shipIds;
    uint256 playerId = rosterMultiShipsTransferred.playerId;
    uint32 sequenceNumber = rosterMultiShipsTransferred.sequenceNumber;

    if (rosterData.shipIds.length == 0) {
      revert EmptyShipIdsInSourceRoster(playerId, sequenceNumber);
    }

    for (uint256 i = 0; i < shipIds.length; i++) {
      uint256 shipId = shipIds[i];
      ShipData memory shipData = Ship.get(shipId);

      ShipUtil.assertShipOwnership(shipData, shipId, playerId, sequenceNumber);

      rosterData.shipIds = ShipIdUtil.removeShipId(rosterData.shipIds, shipId);
      toRoster.shipIds = ShipIdUtil.addShipId(
        toRoster.shipIds,
        shipId,
        rosterMultiShipsTransferred.toPosition + uint64(i)
      );

      shipData.playerId = rosterMultiShipsTransferred.toRosterPlayerId;
      shipData.rosterSequenceNumber = rosterMultiShipsTransferred.toRosterSequenceNumber;
      Ship.set(shipId, shipData);
    }

    rosterData.speed = rosterData.calculateRosterSpeed();
    rosterData.coordinatesUpdatedAt = rosterMultiShipsTransferred.transferredAt;

    toRoster.speed = toRoster.calculateRosterSpeed();
    toRoster.coordinatesUpdatedAt = rosterMultiShipsTransferred.transferredAt;
    Roster.set(
      rosterMultiShipsTransferred.toRosterPlayerId,
      rosterMultiShipsTransferred.toRosterSequenceNumber,
      toRoster
    );

    return rosterData;
  }
}
