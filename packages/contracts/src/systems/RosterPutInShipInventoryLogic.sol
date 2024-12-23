// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipInventoryPutIn } from "./RosterEvents.sol";
import { RosterData, Roster, PlayerData, Player, ShipData, Ship } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { RosterStatus } from "./RosterStatus.sol";
import { PlayerDelegatecallLib } from "./PlayerDelegatecallLib.sol";
import { ShipDelegatecallLib } from "./ShipDelegatecallLib.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { RosterId } from "./RosterId.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";
import { RosterDelegatecallLib } from "./RosterDelegatecallLib.sol";
import { UpdateLocationParams } from "./UpdateLocationParams.sol";

library RosterPutInShipInventoryLogic {
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
    UpdateLocationParams memory updateLocationParams,
    RosterData memory rosterData
  ) internal returns (RosterShipInventoryPutIn memory) {
    uint32 updatedCoordinatesX = updateLocationParams.updatedCoordinates.x;
    uint32 updatedCoordinatesY = updateLocationParams.updatedCoordinates.y;
    uint16 updatedSailSegment = updateLocationParams.updatedSailSegment;

    PlayerUtil.assertSenderIsPlayerOwner(playerId);
    PlayerData memory player = Player.get(playerId);
    RosterId memory rosterId = RosterId(playerId, sequenceNumber);
    RosterUtil.assertPlayerIsRosterOwner(playerId, rosterId);
    RosterUtil.assertRosterIsNotUnassignedShips(sequenceNumber);
    // Check if the ship is in the roster
    if (!ShipIdUtil.containsShipId(rosterData.shipIds, shipId)) {
      revert ShipNotInRoster(shipId);
    }

    // if (rosterData.status == uint8(RosterStatus.UNDERWAY)) {
    //   uint64 currentTimestamp = uint64(block.timestamp);
    //   (bool updatable, uint64 coordinatesUpdatedAt, uint8 newStatus) = rosterData.isCurrentLocationUpdatable(
    //     currentTimestamp,
    //     updatedCoordinatesX,
    //     updatedCoordinatesY
    //   );
    //   if (updatable) {
    //     rosterData.updatedCoordinatesX = updatedCoordinatesX;
    //     rosterData.updatedCoordinatesY = updatedCoordinatesY;
    //     rosterData.coordinatesUpdatedAt = coordinatesUpdatedAt;
    //     rosterData.status = newStatus;
    //   }
    // }
    if (
      updateLocationParams.updatedAt != 0 &&
      updateLocationParams.updatedCoordinates.x != 0 &&
      updateLocationParams.updatedCoordinates.y != 0
    ) {
      RosterDelegatecallLib.updateLocation(playerId, sequenceNumber, updateLocationParams);
    }
    // Reload the roster state
    rosterData = Roster.get(playerId, sequenceNumber);

    rosterData.assertRosterIslandCloseEnoughToTransfer(player.claimedIslandX, player.claimedIslandY);

    return
      RosterShipInventoryPutIn({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        shipId: shipId,
        itemIdQuantityPairs: itemIdQuantityPairs,
        updateLocationParams: updateLocationParams
      });
  }

  function mutate(
    RosterShipInventoryPutIn memory rosterShipInventoryPutIn,
    RosterData memory rosterData
  ) internal returns (RosterData memory) {
    rosterData = Roster.get(rosterShipInventoryPutIn.playerId, rosterShipInventoryPutIn.sequenceNumber);
    uint256 shipId = rosterShipInventoryPutIn.shipId;
    ItemIdQuantityPair[] memory itemIdQuantityPairs = rosterShipInventoryPutIn.itemIdQuantityPairs;

    // Deduct items from player inventory
    PlayerDelegatecallLib.deductItems(rosterShipInventoryPutIn.playerId, itemIdQuantityPairs);

    // Add items to ship inventory
    ShipDelegatecallLib.increaseShipInventory(shipId, itemIdQuantityPairs);

    return rosterData;
  }
}
