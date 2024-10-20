// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandClaimWhitelistRemoved } from "./IslandClaimWhitelistEvents.sol";
import { IslandClaimWhitelistData } from "../codegen/index.sol";

/**
 * @title IslandClaimWhitelistRemoveLogic Library
 * @dev Implements the IslandClaimWhitelist.Remove method.
 */
library IslandClaimWhitelistRemoveLogic {
  error AccountNotInWhitelist(address account);

  /**
   * @notice Verifies the IslandClaimWhitelist.Remove command.
   * @param islandClaimWhitelistData The current state the IslandClaimWhitelist.
   * @return A IslandClaimWhitelistRemoved event struct.
   */
  function verify(
    address accountAddress,
    IslandClaimWhitelistData memory islandClaimWhitelistData
  ) internal pure returns (IslandClaimWhitelistRemoved memory) {
    if (!islandClaimWhitelistData.existing && !islandClaimWhitelistData.allowed) {
      revert AccountNotInWhitelist(accountAddress);
    }
    return IslandClaimWhitelistRemoved({ accountAddress: accountAddress });
  }

  /**
   * @notice Performs the state mutation operation of IslandClaimWhitelist.Remove method.
   * @dev This function is called after verification to update the IslandClaimWhitelist's state.
   * @param islandClaimWhitelistRemoved The IslandClaimWhitelistRemoved event struct from the verify function.
   * @param islandClaimWhitelistData The current state of the IslandClaimWhitelist.
   * @return The new state of the IslandClaimWhitelist.
   */
  function mutate(
    IslandClaimWhitelistRemoved memory islandClaimWhitelistRemoved,
    IslandClaimWhitelistData memory islandClaimWhitelistData
  ) internal pure returns (IslandClaimWhitelistData memory) {
    islandClaimWhitelistData.allowed = false;
    return islandClaimWhitelistData;
  }
}
