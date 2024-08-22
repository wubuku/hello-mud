// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { Terrain, TerrainData } from "../codegen/index.sol";
import { TerrainCreated, TerrainUpdated } from "./TerrainEvents.sol";
import { TerrainCreateLogic } from "./TerrainCreateLogic.sol";
import { TerrainUpdateLogic } from "./TerrainUpdateLogic.sol";

contract TerrainSystem is System {
  event TerrainCreatedEvent(int32 indexed x, int32 indexed y, string terrainType, uint8[] foo, bytes bar);

  event TerrainUpdatedEvent(int32 indexed x, int32 indexed y, string terrainType, uint8[] foo, bytes bar);

  function terrainCreate(int32 x, int32 y, string memory terrainType, uint8[] memory foo, bytes memory bar) public {
    TerrainData memory terrainData = Terrain.get(x, y);
    //assert that the terrain does not exist
    require(
      bytes(terrainData.terrainType).length == 0 && terrainData.foo.length == 0 && terrainData.bar.length == 0,
      "Terrain already exists"
    );
    TerrainCreated memory terrainCreated = TerrainCreateLogic.verify(x, y, terrainType, foo, bar);
    emit TerrainCreatedEvent(
      terrainCreated.x,
      terrainCreated.y,
      terrainCreated.terrainType,
      terrainCreated.foo,
      terrainCreated.bar
    );
    TerrainData memory newTerrainData = TerrainCreateLogic.mutate(terrainCreated);
    Terrain.set(x, y, newTerrainData);
  }

  function terrainUpdate(int32 x, int32 y, string memory terrainType, uint8[] memory foo, bytes memory bar) public {
    TerrainData memory terrainData = Terrain.get(x, y);
    require(
      !(bytes(terrainData.terrainType).length == 0 && terrainData.foo.length == 0 && terrainData.bar.length == 0),
      "Terrain does not exist"
    );
    // or "ShouldCreateOnDemand"?
    TerrainUpdated memory terrainUpdated = TerrainUpdateLogic.verify(x, y, terrainType, foo, bar, terrainData);
    emit TerrainUpdatedEvent(
      terrainUpdated.x,
      terrainUpdated.y,
      terrainUpdated.terrainType,
      terrainUpdated.foo,
      terrainUpdated.bar
    );
    TerrainData memory updatedTerrainData = TerrainUpdateLogic.mutate(terrainUpdated, terrainData);
    Terrain.set(x, y, updatedTerrainData);
  }
}
