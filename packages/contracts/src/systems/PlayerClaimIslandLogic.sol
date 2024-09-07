// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandClaimed } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";

library PlayerClaimIslandLogic {
  function verify(
    uint256 id,
    int32 coordinatesX,
    int32 coordinatesY,
    PlayerData memory playerData
  ) internal pure returns (IslandClaimed memory) {
    // TODO ...
    //return IslandClaimed(...);
  }

  function mutate(
    IslandClaimed memory islandClaimed,
    PlayerData memory playerData
  ) internal pure returns (PlayerData memory) {
    // TODO ...
  }
}
