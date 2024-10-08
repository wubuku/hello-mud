// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { Map, MapData } from "../codegen/index.sol";
import { IslandAdded, MapCreated, MapUpdated } from "./MapEvents.sol";
import { MapAddIslandLogic } from "./MapAddIslandLogic.sol";
import { MapCreateLogic } from "./MapCreateLogic.sol";
import { MapUpdateLogic } from "./MapUpdateLogic.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { NamespaceOwner } from "@latticexyz/world/src/codegen/tables/NamespaceOwner.sol";
import { ResourceId, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";

contract MapSystem is System {
  using WorldResourceIdInstance for ResourceId;

  event IslandAddedEvent(uint32 coordinatesX, uint32 coordinatesY);

  event MapCreatedEvent(bool existing, uint32 width, uint32 height);

  event MapUpdatedEvent(bool existing, uint32 width, uint32 height);

  function _requireNamespaceOwner() internal view {
    ResourceId _thisSystemId = SystemRegistry.get(address(this));
    address _thisNamespaceOwner = NamespaceOwner.get(_thisSystemId.getNamespaceId());
    require(_thisNamespaceOwner == _msgSender(), "Require namespace owner");
  }

  function mapAddIsland(uint32 coordinatesX, uint32 coordinatesY, ItemIdQuantityPair[] memory resources) public {
    _requireNamespaceOwner();
    MapData memory mapData = Map.get();
    require(
      !(mapData.existing == false && mapData.width == uint32(0) && mapData.height == uint32(0)),
      "Map does not exist"
    );
    IslandAdded memory islandAdded = MapAddIslandLogic.verify(coordinatesX, coordinatesY, resources, mapData);
    emit IslandAddedEvent(islandAdded.coordinatesX, islandAdded.coordinatesY);
    MapData memory updatedMapData = MapAddIslandLogic.mutate(islandAdded, mapData);
    Map.set(updatedMapData);
  }

  function mapCreate(bool existing, uint32 width, uint32 height) public {
    MapData memory mapData = Map.get();
    require(
      mapData.existing == false && mapData.width == uint32(0) && mapData.height == uint32(0),
      "Map already exists"
    );
    MapCreated memory mapCreated = MapCreateLogic.verify(existing, width, height);
    emit MapCreatedEvent(mapCreated.existing, mapCreated.width, mapCreated.height);
    MapData memory newMapData = MapCreateLogic.mutate(mapCreated);
    Map.set(newMapData);
  }

  function mapUpdate(bool existing, uint32 width, uint32 height) public {
    MapData memory mapData = Map.get();
    require(
      !(mapData.existing == false && mapData.width == uint32(0) && mapData.height == uint32(0)),
      "Map does not exist"
    );
    MapUpdated memory mapUpdated = MapUpdateLogic.verify(existing, width, height, mapData);
    emit MapUpdatedEvent(mapUpdated.existing, mapUpdated.width, mapUpdated.height);
    MapData memory updatedMapData = MapUpdateLogic.mutate(mapUpdated, mapData);
    Map.set(updatedMapData);
  }

}
