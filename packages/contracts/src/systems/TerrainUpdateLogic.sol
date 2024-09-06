// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { TerrainUpdated } from "./TerrainEvents.sol";
import { TerrainData } from "../codegen/index.sol";

library TerrainUpdateLogic {
  function verify(
    int32 x,
    int32 y,
    string memory terrainType,
    uint8[] memory foo,
    bytes memory bar,
    TerrainData memory terrainData
  ) internal pure returns (TerrainUpdated memory) {
    return TerrainUpdated(x, y, terrainType, foo, bar);
  }

  function mutate(
    TerrainUpdated memory terrainUpdated,
    TerrainData memory terrainData
  ) internal pure returns (TerrainData memory) {
    // TODO ...
  }
}
