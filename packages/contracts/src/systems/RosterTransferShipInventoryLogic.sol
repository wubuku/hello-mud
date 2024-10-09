// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipInventoryTransferred } from "./RosterEvents.sol";
import { RosterData, PlayerData, Player, ShipData, Ship } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";
import { ShipDelegatecallLib } from "./ShipDelegatecallLib.sol";
import { RosterId } from "./RosterId.sol";
import { RosterDataInstance } from "../utils/RosterDataInstance.sol";

library RosterTransferShipInventoryLogic {
  using RosterDataInstance for RosterData;

  error SenderNotPlayerOwner();
  error PlayerNotRosterOwner();
  error ShipNotInRoster(uint256 shipId);

  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 fromShipId,
    uint256 toShipId,
    ItemIdQuantityPair[] memory itemIdQuantityPairs,
    RosterData memory rosterData
  ) internal view returns (RosterShipInventoryTransferred memory) {
    PlayerUtil.assertSenderIsPlayerOwner(playerId);
    PlayerData memory player = Player.get(playerId);
    RosterId memory rosterId = RosterId(playerId, sequenceNumber);
    RosterUtil.assertPlayerIsRosterOwner(playerId, rosterId);
    // TODO: Implement additional checks

    if (!ShipIdUtil.containsShipId(rosterData.shipIds, fromShipId)) {
      revert ShipNotInRoster(fromShipId);
    }
    if (!ShipIdUtil.containsShipId(rosterData.shipIds, toShipId)) {
      revert ShipNotInRoster(toShipId);
    }

    return
      RosterShipInventoryTransferred({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        fromShipId: fromShipId,
        toShipId: toShipId,
        itemIdQuantityPairs: itemIdQuantityPairs
      });
  }

  function mutate(
    RosterShipInventoryTransferred memory rosterShipInventoryTransferred,
    RosterData memory rosterData
  ) internal returns (RosterData memory) {
    uint256 fromShipId = rosterShipInventoryTransferred.fromShipId;
    uint256 toShipId = rosterShipInventoryTransferred.toShipId;
    ItemIdQuantityPair[] memory itemIdQuantityPairs = rosterShipInventoryTransferred.itemIdQuantityPairs;

    // Deduct items from the source ship's inventory
    ShipDelegatecallLib.deductShipInventory(fromShipId, itemIdQuantityPairs);

    // Add items to the destination ship's inventory
    ShipDelegatecallLib.increaseShipInventory(toShipId, itemIdQuantityPairs);

    // TODO: Update rosterData if necessary
    // For example, you might want to update some statistics or timestamps

    return rosterData;
  }
}
