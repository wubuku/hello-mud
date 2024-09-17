// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { MapCreated } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";

library MapCreateLogic {
  function verify(
    bool existing,
    uint32 width,
    uint32 height
  ) internal pure returns (MapCreated memory) {
    return MapCreated(existing, width, height);
  }

  function mutate(
    MapCreated memory mapCreated
  ) internal pure returns (MapData memory) {
    MapData memory mapData;
    mapData.existing = mapCreated.existing;
    mapData.width = mapCreated.width;
    mapData.height = mapCreated.height;
    return mapData;
  }
}
