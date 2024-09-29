// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { TerrainUpdated } from "./TerrainEvents.sol";
import { TerrainData } from "../codegen/index.sol";

/**
 * @title TerrainUpdateLogic Library
 * @dev Implements the Terrain.Update method.
 */
library TerrainUpdateLogic {
  /**
   * @notice Verifies the Terrain.Update command.
   * @param terrainData The current state the Terrain.
   * @return A TerrainUpdated event struct.
   */
  function verify(
    uint32 x,
    uint32 y,
    string memory terrainType,
    uint8[] memory foo,
    bytes memory bar,
    TerrainData memory terrainData
  ) internal pure returns (TerrainUpdated memory) {
    return TerrainUpdated(x, y, terrainType, foo, bar);
  }

  /**
   * @notice Performs the state mutation operation of Terrain.Update method.
   * @dev This function is called after verification to update the Terrain's state.
   * @param terrainUpdated The TerrainUpdated event struct from the verify function.
   * @param terrainData The current state of the Terrain.
   * @return The new state of the Terrain.
   */
  function mutate(
    TerrainUpdated memory terrainUpdated,
    TerrainData memory terrainData
  ) internal pure returns (TerrainData memory) {
    terrainData.terrainType = terrainUpdated.terrainType;
    terrainData.foo = terrainUpdated.foo;
    terrainData.bar = terrainUpdated.bar;
    return terrainData;
  }
}
