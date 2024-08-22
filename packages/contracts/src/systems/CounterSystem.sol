// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { Counter } from "../codegen/index.sol";
import { CounterIncreased } from "./CounterEvents.sol";
import { CounterIncreaseLogic } from "./CounterIncreaseLogic.sol";

contract CounterSystem is System {
  event CounterIncreasedEvent(uint32 oldValue);

  function counterIncrease() public returns (uint32) {
    uint32 counter = Counter.get();
    CounterIncreased memory counterIncreased = CounterIncreaseLogic.verify(counter);
    emit CounterIncreasedEvent(counterIncreased.oldValue);
    uint32 newValue = CounterIncreaseLogic.mutate(counterIncreased, counter);
    Counter.set(newValue);
    return newValue;
  }
}
