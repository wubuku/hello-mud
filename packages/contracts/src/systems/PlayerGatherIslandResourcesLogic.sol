// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerIslandResourcesGathered } from "./PlayerEvents.sol";
import { PlayerData, MapLocation } from "../codegen/index.sol";
import { MapDelegatecallLib } from "./MapDelegatecallLib.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
import { PlayerInventoryLib, PlayerInventoryData } from "./PlayerInventoryLib.sol";
import { PlayerInventoryUpdateUtil } from "../utils/PlayerInventoryUpdateUtil.sol";

library PlayerGatherIslandResourcesLogic {
  error SenderNotPlayerOwner(address sender, address owner);
  error PlayerNotIslandOwner(uint256 playerId, uint32 x, uint32 y);
  error ELocationNotFound(uint32 x, uint32 y);

  function verify(
    uint256 id,
    PlayerData memory playerData
  ) internal view returns (PlayerIslandResourcesGathered memory) {
    if (playerData.owner != WorldContextConsumerLib._msgSender()) {
      revert SenderNotPlayerOwner(WorldContextConsumerLib._msgSender(), playerData.owner);
    }

    if (playerData.claimedIslandX == 0 || playerData.claimedIslandY == 0) {
      revert PlayerNotIslandOwner(id, playerData.claimedIslandX, playerData.claimedIslandY);
    }

    if (!MapLocation.getExisting(playerData.claimedIslandX, playerData.claimedIslandY)) {
      revert ELocationNotFound(playerData.claimedIslandX, playerData.claimedIslandY);
    }

    return PlayerIslandResourcesGathered(id);
  }

  function mutate(
    PlayerIslandResourcesGathered memory playerIslandResourcesGathered,
    PlayerData memory playerData
  ) internal returns (PlayerData memory) {
    ItemIdQuantityPair[] memory resources = MapDelegatecallLib.gatherIslandResources(
      playerIslandResourcesGathered.id,
      playerData.claimedIslandX,
      playerData.claimedIslandY
    );

    addInventoryByGatheredResources(playerIslandResourcesGathered.id, resources);

    return playerData;
  }

  function addInventoryByGatheredResources(uint256 playerId, ItemIdQuantityPair[] memory resources) private {
    for (uint i = 0; i < resources.length; i++) {
      PlayerInventoryUpdateUtil.addOrUpdateInventory(playerId, resources[i].itemId, resources[i].quantity);
    }
  }
}
