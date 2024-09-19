// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerXpAndItemsIncreased } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library PlayerIncreaseExperienceAndItemsLogic {
  function verify(
    uint256 id,
    uint32 experienceGained,
    ItemIdQuantityPair[] memory items,
    uint16 newLevel,
    PlayerData memory playerData
  ) internal pure returns (PlayerXpAndItemsIncreased memory) {
    // TODO ...
    //return PlayerXpAndItemsIncreased(...);
  }

  function mutate(
    PlayerXpAndItemsIncreased memory playerXpAndItemsIncreased,
    PlayerData memory playerData
  ) internal pure returns (PlayerData memory) {
    // TODO ...
  }
}
