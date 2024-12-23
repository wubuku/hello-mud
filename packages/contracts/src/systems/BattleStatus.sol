// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

library BattleStatus {
  uint8 constant IN_PROGRESS = 0;
  uint8 constant ENDED = 1;
  uint8 constant LOOTED = 2;

  function isValid(uint8 v) internal pure returns (bool) {
    return v == IN_PROGRESS || v == ENDED || v == LOOTED;
  }

  function allValidValues() internal pure returns (uint8[] memory) {
    uint8[] memory values = new uint8[](3);
    values[0] = IN_PROGRESS;
    values[1] = ENDED;
    values[2] = LOOTED;
    return values;
  }
}

