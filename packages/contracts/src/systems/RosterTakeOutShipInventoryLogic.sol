// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipInventoryTakenOut } from "./RosterEvents.sol";
import { RosterData, PlayerData, Player, ShipData, Ship } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { RosterStatus } from "./RosterStatus.sol";
import { PlayerDelegationLib } from "./PlayerDelegationLib.sol";
import { ShipDelegationLib } from "./ShipDelegationLib.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { RosterId } from "./RosterId.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";

library RosterTakeOutShipInventoryLogic {
  using RosterDataInstance for RosterData;

  error SenderNotPlayerOwner();
  error PlayerNotRosterOwner();
  error RosterIsUnassignedShips();
  error RosterNotCloseEnoughToTransfer();
  error ShipNotInRoster(uint256 shipId);

  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    ItemIdQuantityPair[] memory itemIdQuantityPairs,
    uint32 updatedCoordinatesX,
    uint32 updatedCoordinatesY,
    RosterData memory rosterData
  ) internal view returns (RosterShipInventoryTakenOut memory) {
    PlayerUtil.assertSenderIsPlayerOwner(playerId);
    PlayerData memory player = Player.get(playerId);
    RosterId memory rosterId = RosterId(playerId, sequenceNumber);
    RosterUtil.assertPlayerIsRosterOwner(playerId, rosterId);
    RosterUtil.assertRosterIsNotUnassignedShips(sequenceNumber);
    // Check if the ship is in the roster
    if (!ShipIdUtil.containsShipId(rosterData.shipIds, shipId)) {
      revert ShipNotInRoster(shipId);
    }

    if (rosterData.status == uint8(RosterStatus.UNDERWAY)) {
      uint64 currentTimestamp = uint64(block.timestamp);

      (bool updatable, uint64 coordinatesUpdatedAt, uint8 newStatus) = rosterData.isCurrentLocationUpdatable(
        currentTimestamp,
        updatedCoordinatesX,
        updatedCoordinatesY
      );

      if (updatable) {
        rosterData.updatedCoordinatesX = updatedCoordinatesX;
        rosterData.updatedCoordinatesY = updatedCoordinatesY;
        rosterData.coordinatesUpdatedAt = coordinatesUpdatedAt;
        rosterData.status = newStatus;
      }
    }

    rosterData.assertRosterIslandCloseEnoughToTransfer(player.claimedIslandX, player.claimedIslandY);

    return
      RosterShipInventoryTakenOut({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        shipId: shipId,
        itemIdQuantityPairs: itemIdQuantityPairs,
        updatedCoordinatesX: updatedCoordinatesX,
        updatedCoordinatesY: updatedCoordinatesY
      });
  }

  function mutate(
    RosterShipInventoryTakenOut memory rosterShipInventoryTakenOut,
    RosterData memory rosterData
  ) internal returns (RosterData memory) {
    uint256 shipId = rosterShipInventoryTakenOut.shipId;
    ItemIdQuantityPair[] memory itemIdQuantityPairs = rosterShipInventoryTakenOut.itemIdQuantityPairs;

    // Deduct items from ship inventory
    ShipDelegationLib.deductShipInventory(shipId, itemIdQuantityPairs);

    // Add items to player inventory
    PlayerDelegationLib.increaseExperienceAndItems(
      rosterShipInventoryTakenOut.playerId,
      0, // ignore experience gained
      itemIdQuantityPairs,
      0 // ignore new level update
    );

    return rosterData;
  }
}
