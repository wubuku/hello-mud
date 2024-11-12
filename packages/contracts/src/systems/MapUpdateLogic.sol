// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { MapUpdated } from "./MapEvents.sol";
import { MapData } from "../codegen/index.sol";

/**
 * @title MapUpdateLogic Library
 * @dev Implements the Map.Update method.
 */
library MapUpdateLogic {
  /**
   * @notice Verifies the Map.Update command.
   * @param mapData The current state the Map.
   * @return A MapUpdated event struct.
   */
  function verify(
    bool existing,
    bool islandClaimWhitelistEnabled,
    uint32 islandResourceRenewalQuantity, 
    uint64 islandResourceRenewalTime,
    uint32[] memory islandRenewableItemIds,
    MapData memory mapData
  ) internal pure returns (MapUpdated memory) {
    return MapUpdated(existing, islandClaimWhitelistEnabled, islandResourceRenewalQuantity, islandResourceRenewalTime, islandRenewableItemIds);
  }

  /**
   * @notice Performs the state mutation operation of Map.Update method.
   * @dev This function is called after verification to update the Map's state.
   * @param mapUpdated The MapUpdated event struct from the verify function.
   * @param mapData The current state of the Map.
   * @return The new state of the Map.
   */
  function mutate(
    MapUpdated memory mapUpdated,
    MapData memory mapData
  ) internal pure returns (MapData memory) {
    mapData.existing = mapUpdated.existing;
    mapData.islandClaimWhitelistEnabled = mapUpdated.islandClaimWhitelistEnabled;
    return mapData;
  }
}
