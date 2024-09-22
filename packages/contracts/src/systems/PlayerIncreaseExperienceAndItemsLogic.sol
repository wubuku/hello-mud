// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerXpAndItemsIncreased } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { PlayerInventoryUpdateUtil } from "../utils/PlayerInventoryUpdateUtil.sol";

error PlayerIdZero();
//error ExperienceGainedZeroOrNegative(uint32 experienceGained);
error NewLevelLowerThanCurrent(uint16 newLevel, uint16 currentLevel);

library PlayerIncreaseExperienceAndItemsLogic {
  function verify(
    uint256 id,
    uint32 experienceGained,
    ItemIdQuantityPair[] memory items,
    uint16 newLevel,
    PlayerData memory playerData
  ) internal pure returns (PlayerXpAndItemsIncreased memory) {
    if (id == 0) revert PlayerIdZero();
    //if (experienceGained == 0) revert ExperienceGainedZeroOrNegative(experienceGained);
    if (newLevel >= uint16(0) && newLevel < playerData.level)
      revert NewLevelLowerThanCurrent(newLevel, playerData.level);

    return PlayerXpAndItemsIncreased(id, experienceGained, items, newLevel);
  }

  function mutate(
    PlayerXpAndItemsIncreased memory playerXpAndItemsIncreased,
    PlayerData memory playerData
  ) internal returns (PlayerData memory) {
    uint256 playerId = playerXpAndItemsIncreased.id;
    uint32 increasedExperience = playerXpAndItemsIncreased.experienceGained;
    uint16 newLevel = playerXpAndItemsIncreased.newLevel;

    playerData.experience += increasedExperience;
    if (newLevel > playerData.level) {
      playerData.level = newLevel;
    }

    for (uint i = 0; i < playerXpAndItemsIncreased.items.length; i++) {
      ItemIdQuantityPair memory item = playerXpAndItemsIncreased.items[i];
      PlayerInventoryUpdateUtil.addOrUpdateInventory(playerId, item.itemId, item.quantity);
    }

    return playerData;
  }
}
