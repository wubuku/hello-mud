// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { TerrainCreated } from "./TerrainEvents.sol";
import { TerrainData } from "../codegen/index.sol";
//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

/**
 * @title TerrainCreateLogic Library
 * @dev Implements the Terrain.Create method.
 */
library TerrainCreateLogic {
  /**
   * @notice Verifies the Terrain.Create command.
   * @return A TerrainCreated event struct.
   */
  function verify(
    uint32 x,
    uint32 y,
    string memory terrainType,
    uint8[] memory foo,
    bytes memory bar
  ) internal pure returns (TerrainCreated memory) {
    return TerrainCreated(x, y, terrainType, foo, bar);
  }

  /**
   * @notice Performs the state mutation operation of Terrain.Create method.
   * @dev This function is called after verification to update the Terrain's state.
   * @param terrainCreated The TerrainCreated event struct from the verify function.
   * @return The new state of the Terrain.
   */
  function mutate(
    TerrainCreated memory terrainCreated
  ) internal pure returns (TerrainData memory) {
    TerrainData memory terrainData;
    terrainData.terrainType = terrainCreated.terrainType;
    terrainData.foo = terrainCreated.foo;
    terrainData.bar = terrainCreated.bar;
    return terrainData;
  }
}
