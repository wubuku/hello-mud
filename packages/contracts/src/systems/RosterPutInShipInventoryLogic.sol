// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipInventoryPutIn } from "./RosterEvents.sol";
import { RosterData, PlayerData, Player, ShipData, Ship } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { RosterStatus } from "./RosterStatus.sol";
import { PlayerDelegationLib } from "./PlayerDelegationLib.sol";
import { ShipDelegationLib } from "./ShipDelegationLib.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { RosterId } from "./RosterId.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";

library RosterPutInShipInventoryLogic {
  using RosterDataInstance for RosterData;

  error SenderNotPlayerOwner();
  error PlayerNotRosterOwner();
  error RosterIsUnassignedShips();
  error RosterNotCloseEnoughToTransfer();

  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    ItemIdQuantityPair[] memory itemIdQuantityPairs,
    uint32 updatedCoordinatesX,
    uint32 updatedCoordinatesY,
    RosterData memory rosterData
  ) internal view returns (RosterShipInventoryPutIn memory) {
    PlayerUtil.assertSenderIsPlayerOwner(playerId);
    PlayerData memory player = Player.get(playerId);
    RosterId memory rosterId = RosterId(playerId, sequenceNumber);
    RosterUtil.assertPlayerIsRosterOwner(playerId, rosterId);
    RosterUtil.assertRosterIsNotUnassignedShips(sequenceNumber);

    if (rosterData.status == uint8(RosterStatus.UNDERWAY)) {
      // TODO: Implement clock functionality
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
      RosterShipInventoryPutIn({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        shipId: shipId,
        itemIdQuantityPairs: itemIdQuantityPairs,
        updatedCoordinatesX: updatedCoordinatesX,
        updatedCoordinatesY: updatedCoordinatesY
      });
  }

  function mutate(
    RosterShipInventoryPutIn memory rosterShipInventoryPutIn,
    RosterData memory rosterData
  ) internal returns (RosterData memory) {
    uint256 shipId = rosterShipInventoryPutIn.shipId;
    ItemIdQuantityPair[] memory itemIdQuantityPairs = rosterShipInventoryPutIn.itemIdQuantityPairs;

    // Deduct items from player inventory
    PlayerDelegationLib.deductItems(rosterShipInventoryPutIn.playerId, itemIdQuantityPairs);

    // Add items to ship inventory
    ShipDelegationLib.increaseShipInventory(shipId, itemIdQuantityPairs);

    return rosterData;
  }
}
