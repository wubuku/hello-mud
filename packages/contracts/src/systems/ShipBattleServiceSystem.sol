// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";

contract ShipBattleServiceSystem is System {
  function shipBattleServiceInitiateBattleAndAutoPlayTillEnd(uint256 playerId, int32 initiatorCoordinatesX, int32 initiatorCoordinatesY, int32 responderCoordinatesX, int32 responderCoordinatesY) public {
    // TODO ...
  }

  function shipBattleServiceAutoPlayTillEnd(uint256 shipBattleId, uint256 playerId) public {
    // TODO ...
  }

}
