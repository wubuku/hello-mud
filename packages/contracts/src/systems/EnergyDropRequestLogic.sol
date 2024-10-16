// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { EnergyDropRequested } from "./EnergyDropEvents.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
import { EnergyToken } from "../codegen/index.sol";
import { SafeERC20, IERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title EnergyDropRequestLogic Library
 * @dev Implements the EnergyDrop.Request method.
 */
library EnergyDropRequestLogic {
  using SafeERC20 for IERC20;

  uint256 constant A_DROP_AMOUNT = 200 * 10 ** 18; // 200 ENERGY tokens?
  uint256 constant TIME_INTERVAL = 24 * 60 * 60; // 24 hours in seconds

  error InvalidTokenAddress(address tokenAddress);
  error InsufficientBalance(uint256 balance, uint256 requiredAmount);
  error InsufficientTimeInterval(uint256 lastDropTime, uint256 currentTime);
  error SenderHasNoPermission(address sender, address owner);

  struct GrantRecord {
    uint256 grantedAt;
    uint256 amount;
  }

  /**
   * @notice Verifies the EnergyDrop.Request command.
   * @param lastDroppedAt The last time energy was dropped for this account.
   * @return A EnergyDropRequested event struct.
   */
  function verify(address accountAddress, uint64 lastDroppedAt) internal view returns (EnergyDropRequested memory) {
    address tokenAddress = EnergyToken.get();
    if (tokenAddress == address(0)) {
      revert InvalidTokenAddress(tokenAddress);
    }

    if (accountAddress != WorldContextConsumerLib._msgSender()) {
      revert SenderHasNoPermission(WorldContextConsumerLib._msgSender(), accountAddress);
    }

    IERC20 token = IERC20(tokenAddress);
    uint256 balance = token.balanceOf(address(this));
    if (balance < A_DROP_AMOUNT) {
      revert InsufficientBalance(balance, A_DROP_AMOUNT);
    }

    uint256 currentTime = block.timestamp;
    if (currentTime - lastDroppedAt < TIME_INTERVAL) {
      revert InsufficientTimeInterval(lastDroppedAt, currentTime);
    }

    return EnergyDropRequested({ accountAddress: accountAddress, amount: A_DROP_AMOUNT });
  }

  /**
   * @notice Performs the state mutation operation of EnergyDrop.Request method.
   * @dev This function is called after verification to update the EnergyDrop's state.
   * @param energyDropRequested The EnergyDropRequested event struct from the verify function.
   * @param lastDroppedAt The current state of the EnergyDrop.
   * @return The new state of the EnergyDrop.
   */
  function mutate(EnergyDropRequested memory energyDropRequested, uint64 lastDroppedAt) internal returns (uint64) {
    address tokenAddress = EnergyToken.get();
    require(tokenAddress != address(0), "Invalid token address");

    IERC20 token = IERC20(tokenAddress);
    token.safeTransfer(energyDropRequested.accountAddress, energyDropRequested.amount);

    return uint64(block.timestamp);
  }
}
