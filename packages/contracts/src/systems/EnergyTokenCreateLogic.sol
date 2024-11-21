// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { EnergyTokenCreated } from "./EnergyTokenEvents.sol";
import { EnergyTokenData } from "../codegen/index.sol";

/**
 * @title EnergyTokenCreateLogic Library
 * @dev Implements the EnergyToken.Create method.
 */
library EnergyTokenCreateLogic {
  /**
   * @notice Verifies the EnergyToken.Create command.
   * @return A EnergyTokenCreated event struct.
   */
  function verify(
    address tokenAddress,
    uint256 faucetDropAmount,
    uint64 faucetDropInterval
  ) internal pure returns (EnergyTokenCreated memory) {
    return EnergyTokenCreated(tokenAddress, faucetDropAmount, faucetDropInterval);
  }

  /**
   * @notice Performs the state mutation operation of EnergyToken.Create method.
   * @dev This function is called after verification to update the EnergyToken's state.
   * @param energyTokenCreated The EnergyTokenCreated event struct from the verify function.
   * @return The new state of the EnergyToken.
   */
  function mutate(
    EnergyTokenCreated memory energyTokenCreated
  ) internal pure returns (EnergyTokenData memory) {
    EnergyTokenData memory energyTokenData;
    energyTokenData.tokenAddress = energyTokenCreated.tokenAddress;
    energyTokenData.faucetDropAmount = energyTokenCreated.faucetDropAmount;
    energyTokenData.faucetDropInterval = energyTokenCreated.faucetDropInterval;
    return energyTokenData;
  }
}
