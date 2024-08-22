// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CounterIncreased } from "./CounterEvents.sol";

library CounterIncreaseLogic {
  function verify(uint32 oldValue) internal pure returns (CounterIncreased memory) {
    return CounterIncreased(oldValue);
  }

  function mutate(CounterIncreased memory counterIncreased, uint32 value) internal pure returns (uint32) {
    counterIncreased.oldValue;
    return value + 1;
  }
}
