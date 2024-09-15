// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { EnergyTokenCreated } from "./EnergyTokenEvents.sol";

library EnergyTokenCreateLogic {
  function verify(
    address tokenAddress
  ) internal pure returns (EnergyTokenCreated memory) {
    return EnergyTokenCreated(tokenAddress);
  }

  function mutate(
    EnergyTokenCreated memory energyTokenCreated
  ) internal pure returns (address) {
    address tokenAddress;
    tokenAddress = energyTokenCreated.tokenAddress;
    return tokenAddress;
  }
}
