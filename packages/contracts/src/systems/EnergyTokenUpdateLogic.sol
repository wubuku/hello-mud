// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { EnergyTokenUpdated } from "./EnergyTokenEvents.sol";
import { EnergyTokenData } from "../codegen/index.sol";

/**
 * @title EnergyTokenUpdateLogic Library
 * @dev Implements the EnergyToken.Update method.
 */
library EnergyTokenUpdateLogic {
  /**
   * @notice Verifies the EnergyToken.Update command.
   * @param energyTokenData The current state the EnergyToken.
   * @return A EnergyTokenUpdated event struct.
   */
  function verify(
    address tokenAddress,
    uint256 faucetDropAmount,
    uint64 faucetDropInterval,
    EnergyTokenData memory energyTokenData
  ) internal pure returns (EnergyTokenUpdated memory) {
    return EnergyTokenUpdated(tokenAddress, faucetDropAmount, faucetDropInterval);
  }

  /**
   * @notice Performs the state mutation operation of EnergyToken.Update method.
   * @dev This function is called after verification to update the EnergyToken's state.
   * @param energyTokenUpdated The EnergyTokenUpdated event struct from the verify function.
   * @param energyTokenData The current state of the EnergyToken.
   * @return The new state of the EnergyToken.
   */
  function mutate(
    EnergyTokenUpdated memory energyTokenUpdated,
    EnergyTokenData memory energyTokenData
  ) internal pure returns (EnergyTokenData memory) {
    energyTokenData.tokenAddress = energyTokenUpdated.tokenAddress;
    energyTokenData.faucetDropAmount = energyTokenUpdated.faucetDropAmount;
    energyTokenData.faucetDropInterval = energyTokenUpdated.faucetDropInterval;
    return energyTokenData;
  }
}
