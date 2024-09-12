// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { Map, MapData } from "../codegen/index.sol";
import { MapIslandClaimed } from "./MapEvents.sol";
import { MapClaimIslandLogic } from "./MapClaimIslandLogic.sol";

library MapAggregateLib {
  event MapIslandClaimedEvent(int32 coordinatesX, int32 coordinatesY, uint256 claimedBy, uint64 claimedAt);

  function mapClaimIsland(int32 coordinatesX, int32 coordinatesY, uint256 claimedBy, uint64 claimedAt) internal {
    MapData memory mapData = Map.get();
    require(
      !(mapData.width == 0 && mapData.height == 0),
      "Map does not exist"
    );
    MapIslandClaimed memory mapIslandClaimed = MapClaimIslandLogic.verify(coordinatesX, coordinatesY, claimedBy, claimedAt, mapData);
    emit MapIslandClaimedEvent(mapIslandClaimed.coordinatesX, mapIslandClaimed.coordinatesY, mapIslandClaimed.claimedBy, mapIslandClaimed.claimedAt);
    MapData memory updatedMapData = MapClaimIslandLogic.mutate(mapIslandClaimed, mapData);
    Map.set(updatedMapData);
  }

}
