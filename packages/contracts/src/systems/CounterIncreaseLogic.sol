// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { CounterEvents } from "./CounterEvents.sol";

library CounterIncreaseLogic {
  function verify(uint32 oldValue) internal pure returns (CounterEvents.CounterIncreased memory) {
    return CounterEvents.CounterIncreased(oldValue);
  }

  function mutate(CounterEvents.CounterIncreased memory counterIncreased, uint32 value) internal pure returns (uint32) {
    counterIncreased.oldValue;
    return value + 1;
  }
}