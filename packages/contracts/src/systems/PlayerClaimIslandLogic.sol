// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandClaimed } from "./PlayerEvents.sol";
import { PlayerData, MapLocation } from "../codegen/index.sol";
import { MapDelegatecallLib } from "./MapDelegatecallLib.sol";
import { RosterDelegatecallLib } from "./RosterDelegatecallLib.sol";
import { SkillProcessDelegatecallLib } from "./SkillProcessDelegatecallLib.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
import { SkillType } from "./SkillType.sol";
import { PlayerInventoryLib, PlayerInventoryData } from "./PlayerInventoryLib.sol";
import { SkillProcess, SkillProcessData } from "../codegen/index.sol";
import { SkillProcessUtil } from "../utils/SkillProcessUtil.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { PlayerInventoryUpdateUtil } from "../utils/PlayerInventoryUpdateUtil.sol";
import { IslandClaimWhitelistData, IslandClaimWhitelist } from "../codegen/index.sol";

// import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
// import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
// import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

library PlayerClaimIslandLogic {
  error ESenderHasNoPermission(address sender, address owner);
  error EPlayerAlreadyClaimedIsland(uint32 x, uint32 y);
  //error EForNftHoldersOnly();
  //error ENotForEveryone(address sender);
  error EInvalidClaimIslandSetting(uint8 setting);
  error EInvalidCoordinates(uint32 x, uint32 y);
  error ELocationNotFound(uint32 x, uint32 y);
  error EResourceArraysLengthMismatch(uint256 itemIdsLength, uint256 quantitiesLength);

  // uint8 constant FOR_NFT_HOLDERS_ONLY = 1;
  // uint8 constant FOR_WHITELISTED_ACCOUNTS_ONLY = 2;
  // uint8 constant FOR_EVERYONE = 3;

  function verify(
    uint256 id,
    uint32 coordinatesX,
    uint32 coordinatesY,
    PlayerData memory playerData
  ) internal view returns (IslandClaimed memory) {
    address msgSender = WorldContextConsumerLib._msgSender();

    if (!MapLocation.getExisting(coordinatesX, coordinatesY)) {
      revert ELocationNotFound(coordinatesX, coordinatesY);
    }

    // uint8 claimIslandSetting = MapAggregateLib.getClaimIslandSetting();
    // if (claimIslandSetting == FOR_NFT_HOLDERS_ONLY) {
    //   revert EForNftHoldersOnly();
    // }
    // if (claimIslandSetting != FOR_EVERYONE) {
    //   if (claimIslandSetting == FOR_WHITELISTED_ACCOUNTS_ONLY) {
    //     if (!Xx.isWhitelisted(msgSender)) {
    //       revert ENotForEveryone(msgSender);
    //     }
    //   } else {
    //     revert EInvalidClaimIslandSetting(claimIslandSetting);
    //   }
    // }

    if (playerData.owner != msgSender) {
      revert ESenderHasNoPermission(msgSender, playerData.owner);
    }
    if (playerData.claimedIslandX != 0 || playerData.claimedIslandY != 0) {
      revert EPlayerAlreadyClaimedIsland(playerData.claimedIslandX, playerData.claimedIslandY);
    }

    uint64 claimedAt = uint64(block.timestamp);
    return IslandClaimed(id, coordinatesX, coordinatesY, claimedAt);
  }

  function mutate(
    IslandClaimed memory islandClaimed,
    PlayerData memory playerData
  ) internal returns (PlayerData memory) {
    uint32 coordinatesX = islandClaimed.coordinatesX;
    uint32 coordinatesY = islandClaimed.coordinatesY;
    uint64 claimedAt = islandClaimed.claimedAt;
    uint256 playerId = islandClaimed.id;

    playerData.claimedIslandX = coordinatesX;
    playerData.claimedIslandY = coordinatesY;

    // Add resources from island to player inventory
    addInventoryByIslandResources(playerId, coordinatesX, coordinatesY);

    // Claim island in map
    MapDelegatecallLib.claimIsland(coordinatesX, coordinatesY, playerId, claimedAt);

    createSkillProcesses(playerId);

    // Create rosters
    for (uint32 rosterSequenceNumber = 0; rosterSequenceNumber < 5; rosterSequenceNumber++) {
      RosterUtil.getRosterOriginCoordinates(coordinatesX, coordinatesY, rosterSequenceNumber);
      RosterDelegatecallLib.create(playerId, rosterSequenceNumber, coordinatesX, coordinatesY);
    }

    return playerData;
  }

  function addInventoryByIslandResources(uint256 playerId, uint32 coordinatesX, uint32 coordinatesY) private {
    uint32[] memory resourceItemIds = MapLocation.getResourcesItemIds(coordinatesX, coordinatesY);
    uint32[] memory resourceQuantities = MapLocation.getResourcesQuantities(coordinatesX, coordinatesY);

    if (resourceItemIds.length != resourceQuantities.length) {
      revert EResourceArraysLengthMismatch(resourceItemIds.length, resourceQuantities.length);
    }

    for (uint i = 0; i < resourceItemIds.length; i++) {
      PlayerInventoryUpdateUtil.addOrUpdateInventory(playerId, resourceItemIds[i], resourceQuantities[i]);
    }

    //
    // NOT need to clear resources from the island here.
    //
    // uint32[] memory emptyArray = new uint32[](0);
    // MapLocation.setResourcesItemIds(coordinatesX, coordinatesY, emptyArray);
    // MapLocation.setResourcesQuantities(coordinatesX, coordinatesY, emptyArray);
  }


  function createSkillProcesses(uint256 playerId) internal {
    uint8[4] memory skillTypes = [
      uint8(SkillType.MINING),
      uint8(SkillType.WOODCUTTING),
      uint8(SkillType.FARMING),
      uint8(SkillType.CRAFTING)
    ];
    for (uint i = 0; i < skillTypes.length; i++) {
      uint8 maxSeqNumber = SkillProcessUtil.skillTypeMaxSequenceNumber(skillTypes[i]);
      for (uint8 seqNumber = 0; seqNumber <= maxSeqNumber; seqNumber++) {
        SkillProcessDelegatecallLib.create(skillTypes[i], playerId, seqNumber); //, 0, 0, 0, false, 0, 0);
      }
    }
  }
}
