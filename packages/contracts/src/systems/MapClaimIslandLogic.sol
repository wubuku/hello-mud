// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { MapIslandClaimed } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";

library MapClaimIslandLogic {
  function verify(
    uint32 coordinatesX,
    uint32 coordinatesY,
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
