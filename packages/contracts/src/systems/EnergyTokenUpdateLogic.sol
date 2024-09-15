// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { EnergyTokenUpdated } from "./EnergyTokenEvents.sol";

library EnergyTokenUpdateLogic {
  function verify(
    address tokenAddress,
    address s_tokenAddress
  ) internal pure returns (EnergyTokenUpdated memory) {
    return EnergyTokenUpdated(tokenAddress);
  }

  function mutate(
    EnergyTokenUpdated memory energyTokenUpdated,
    address tokenAddress
  ) internal pure returns (address) {
    tokenAddress = energyTokenUpdated.tokenAddress;
    return tokenAddress;
  }
}
