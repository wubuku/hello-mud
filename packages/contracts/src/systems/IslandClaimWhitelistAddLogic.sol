// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandClaimWhitelistAdded } from "./IslandClaimWhitelistEvents.sol";
import { IslandClaimWhitelistData } from "../codegen/index.sol";

//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

/**
 * @title IslandClaimWhitelistAddLogic Library
 * @dev Implements the IslandClaimWhitelist.Add method.
 */
library IslandClaimWhitelistAddLogic {
  error InvalidAccountAddress(address accountAddress);
  error AccountAlreadyWhitelisted(address accountAddress);

  /**
   * @notice Verifies the IslandClaimWhitelist.Add command.
   * @param islandClaimWhitelistData The current state the IslandClaimWhitelist.
   * @return A IslandClaimWhitelistAdded event struct.
   */
  function verify(
    address accountAddress,
    IslandClaimWhitelistData memory islandClaimWhitelistData
  ) internal pure returns (IslandClaimWhitelistAdded memory) {
    if (accountAddress == address(0)) {
      revert InvalidAccountAddress(accountAddress);
    }
    if (islandClaimWhitelistData.existing && islandClaimWhitelistData.allowed) {
      revert AccountAlreadyWhitelisted(accountAddress);
    }

    return IslandClaimWhitelistAdded({ accountAddress: accountAddress });
  }

  /**
   * @notice Performs the state mutation operation of IslandClaimWhitelist.Add method.
   * @dev This function is called after verification to update the IslandClaimWhitelist's state.
   * @param islandClaimWhitelistAdded The IslandClaimWhitelistAdded event struct from the verify function.
   * @param islandClaimWhitelistData The current state of the IslandClaimWhitelist.
   * @return The new state of the IslandClaimWhitelist.
   */
  function mutate(
    IslandClaimWhitelistAdded memory islandClaimWhitelistAdded,
    IslandClaimWhitelistData memory islandClaimWhitelistData
  ) internal pure returns (IslandClaimWhitelistData memory) {
    islandClaimWhitelistData.existing = true;
    islandClaimWhitelistData.allowed = true;
    return islandClaimWhitelistData;
  }
}
