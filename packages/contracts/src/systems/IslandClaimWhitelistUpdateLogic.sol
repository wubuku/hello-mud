// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandClaimWhitelistUpdated } from "./IslandClaimWhitelistEvents.sol";
import { IslandClaimWhitelistData } from "../codegen/index.sol";

//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

/**
 * @title IslandClaimWhitelistUpdateLogic Library
 * @dev Implements the IslandClaimWhitelist.Update method.
 */
library IslandClaimWhitelistUpdateLogic {
  error InvalidAccountAddress(address accountAddress);

  /**
   * @notice Verifies the IslandClaimWhitelist.Update command.
   * @param islandClaimWhitelistData The current state the IslandClaimWhitelist.
   * @return A IslandClaimWhitelistUpdated event struct.
   */
  function verify(
    address accountAddress,
    bool allowed,
    IslandClaimWhitelistData memory islandClaimWhitelistData
  ) internal pure returns (IslandClaimWhitelistUpdated memory) {
    if (accountAddress == address(0)) {
      revert InvalidAccountAddress(accountAddress);
    }

    return IslandClaimWhitelistUpdated({ accountAddress: accountAddress, allowed: allowed });
  }

  /**
   * @notice Performs the state mutation operation of IslandClaimWhitelist.Update method.
   * @dev This function is called after verification to update the IslandClaimWhitelist's state.
   * @param islandClaimWhitelistUpdated The IslandClaimWhitelistUpdated event struct from the verify function.
   * @param islandClaimWhitelistData The current state of the IslandClaimWhitelist.
   * @return The new state of the IslandClaimWhitelist.
   */
  function mutate(
    IslandClaimWhitelistUpdated memory islandClaimWhitelistUpdated,
    IslandClaimWhitelistData memory islandClaimWhitelistData
  ) internal pure returns (IslandClaimWhitelistData memory) {
    islandClaimWhitelistData.existing = true;
    islandClaimWhitelistData.allowed = islandClaimWhitelistUpdated.allowed;
    return islandClaimWhitelistData;
  }
}
