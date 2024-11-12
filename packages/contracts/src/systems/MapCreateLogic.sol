// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { MapCreated } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";

/**
 * @title MapCreateLogic Library
 * @dev Implements the Map.Create method.
 */
library MapCreateLogic {
  /**
   * @notice Verifies the Map.Create command.
   * @return A MapCreated event struct.
   */
  function verify(
    bool existing,
    bool islandClaimWhitelistEnabled,
    uint32 islandResourceRenewalQuantity,
    uint64 islandResourceRenewalTime,
    uint32[] memory islandRenewableItemIds
  ) internal pure returns (MapCreated memory) {
    return MapCreated(existing, islandClaimWhitelistEnabled, islandResourceRenewalQuantity, islandResourceRenewalTime, islandRenewableItemIds);
  }

  /**
   * @notice Performs the state mutation operation of Map.Create method.
   * @dev This function is called after verification to update the Map's state.
   * @param mapCreated The MapCreated event struct from the verify function.
   * @return The new state of the Map.
   */
  function mutate(
    MapCreated memory mapCreated
  ) internal pure returns (MapData memory) {
    MapData memory mapData;
    mapData.existing = mapCreated.existing;
    mapData.islandClaimWhitelistEnabled = mapCreated.islandClaimWhitelistEnabled;
    return mapData;
  }
}
