// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandResourcesAirdropped } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";
//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
//import { MapLocationData } from "../codegen/index.sol";
//import { MapLocation } from "../codegen/index.sol";
// You may need to use the MapLocation library to access and modify the state (MapLocationData) of the MapLocation entity within the Map aggregate


/**
 * @title MapAirdropLogic Library
 * @dev Implements the Map.Airdrop method.
 */
library MapAirdropLogic {
  /**
   * @notice Verifies the Map.Airdrop command.
   * @param mapData The current state the Map.
   * @return A IslandResourcesAirdropped event struct.
   */
  function verify(
    uint32 coordinatesX,
    uint32 coordinatesY,
    uint32[] memory resourcesItemIds,
    uint32[] memory resourcesQuantities,
    MapData memory mapData
  ) internal pure returns (IslandResourcesAirdropped memory) {
    // If necessary, change state mutability modifier of the function from `pure` to `view` or just delete `pure`.
    //
    // Note: Do not arbitrarily add parameters to functions or fields to structs.
    //
    // The message sender can be obtained like this: `WorldContextConsumerLib._msgSender()`
    //
    // TODO: Check arguments, throw if illegal.
    /*
    return IslandResourcesAirdropped({
      coordinatesX: // type: uint32. The X of the Coordinates. Coordinates: The coordinates of the island to airdrop resources to
      coordinatesY: // type: uint32. The Y of the Coordinates. Coordinates: The coordinates of the island to airdrop resources to
      resourcesItemIds: // type: uint32[]
      resourcesQuantities: // type: uint32[]
    });
    */
  }

  /**
   * @notice Performs the state mutation operation of Map.Airdrop method.
   * @dev This function is called after verification to update the Map's state.
   * @param islandResourcesAirdropped The IslandResourcesAirdropped event struct from the verify function.
   * @param mapData The current state of the Map.
   * @return The new state of the Map.
   */
  function mutate(
    IslandResourcesAirdropped memory islandResourcesAirdropped,
    MapData memory mapData
  ) internal pure returns (MapData memory) {
    // If necessary, change state mutability modifier of the function from `pure` to `view` or just delete `pure`.

    // NOTE: The MapLocation entity is managed separately.
    // The actual storage of the MapLocation (MapLocationData) would be handled by the MapLocation library.
    // Note: Functions cannot be declared as pure or view if you modify the state of the MapLocation entity.

    //
    // The fields (types and names) of the struct MapLocationData:
    //   uint32 type_
    //   uint256 occupiedBy
    //   uint64 gatheredAt
    //   bool existing
    //   uint32[] resourcesItemIds
    //   uint32[] resourcesQuantities
    //

    //
    // The fields (types and names) of the struct MapData:
    //   bool existing
    //   bool islandClaimWhitelistEnabled
    //

    // TODO: update state properties...
    //mapData.{STATE_PROPERTY} = islandResourcesAirdropped.{EVENT_PROPERTY};
    return mapData;
  }
}
