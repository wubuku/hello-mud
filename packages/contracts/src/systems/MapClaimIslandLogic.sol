// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { MapIslandClaimed } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";

library MapClaimIslandLogic {
  function verify(
    int32 coordinatesX,
    int32 coordinatesY,
    uint256 claimedBy,
    uint64 claimedAt,
    MapData memory mapData
  ) internal pure returns (MapIslandClaimed memory) {
    // TODO ...
    //return MapIslandClaimed(...);
  }

  function mutate(
    MapIslandClaimed memory mapIslandClaimed,
    MapData memory mapData
  ) internal pure returns (MapData memory) {
    // TODO ...
  }
}
