// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipBattleMoveMade } from "./ShipBattleEvents.sol";
import { ShipBattleData } from "../codegen/index.sol";

library ShipBattleMakeMoveLogic {
  function verify(
    uint256 id,
    uint8 attackerCommand,
    ShipBattleData memory shipBattleData
  ) internal pure returns (ShipBattleMoveMade memory) {
    // TODO ...
    //return ShipBattleMoveMade(...);
  }

  function mutate(
    ShipBattleMoveMade memory shipBattleMoveMade,
    ShipBattleData memory shipBattleData
  ) internal pure returns (ShipBattleData memory) {
    shipBattleData.status = 2; // Just for testing. TODO ...
    // TODO ...
    return shipBattleData;
  }
}
