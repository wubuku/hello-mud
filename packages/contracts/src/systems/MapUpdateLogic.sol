// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { MapUpdated } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";

library MapUpdateLogic {
  function verify(
    bool existing,
    uint32 width,
    uint32 height,
    MapData memory mapData
  ) internal pure returns (MapUpdated memory) {
    return MapUpdated(existing, width, height);
  }

  function mutate(
    MapUpdated memory mapUpdated,
    MapData memory mapData
  ) internal pure returns (MapData memory) {
    mapData.existing = mapUpdated.existing;
    mapData.width = mapUpdated.width;
    mapData.height = mapUpdated.height;
    return mapData;
  }
}
