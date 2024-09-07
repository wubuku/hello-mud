// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerIslandResourcesGathered } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";

library PlayerGatherIslandResourcesLogic {
  function verify(
    uint256 id,
    PlayerData memory playerData
  ) internal pure returns (PlayerIslandResourcesGathered memory) {
    // TODO ...
    //return PlayerIslandResourcesGathered(...);
  }

  function mutate(
    PlayerIslandResourcesGathered memory playerIslandResourcesGathered,
    PlayerData memory playerData
  ) internal pure returns (PlayerData memory) {
    // TODO ...
  }
}
