// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { TerrainCreated } from "./TerrainEvents.sol";
import { TerrainData } from "../codegen/index.sol";

library TerrainCreateLogic {
  function verify(
    int32 x,
    int32 y,
    string memory terrainType,
    uint8[] memory foo,
    bytes memory bar
  ) internal pure returns (TerrainCreated memory) {
    return TerrainCreated(x, y, terrainType, foo, bar);
  }

  function mutate(
    TerrainCreated memory terrainCreated
  ) internal pure returns (TerrainData memory) {
    // TODO ...
  }
}
