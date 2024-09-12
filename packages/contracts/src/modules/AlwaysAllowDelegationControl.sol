// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { DelegationControl } from "@latticexyz/world/src/DelegationControl.sol";
import { ResourceId } from "@latticexyz/world/src/WorldResourceId.sol";

contract AlwaysAllowDelegationControl is DelegationControl {
  /**
   * Verify a delegation by always returning true
   * @dev This function always allows delegation, use with caution
   * @param delegator The address of the delegator (unused in this implementation)
   * @param systemId The ResourceId of the system being accessed (unused in this implementation)
   * @param callData The calldata of the function being called (unused in this implementation)
   * @return true Always returns true, allowing all delegations
   */
  function verify(address delegator, ResourceId systemId, bytes memory callData) public view returns (bool) {
    // Always return true, allowing all delegations
    return true;
  }

  // Optional: Override supportsInterface if needed
  //   function supportsInterface(bytes4 interfaceId) public pure override returns (bool) {
  //     return super.supportsInterface(interfaceId);
  //   }
}
