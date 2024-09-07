// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipBattleLootTaken } from "./ShipBattleEvents.sol";
import { ShipBattleData } from "../codegen/index.sol";

library ShipBattleTakeLootLogic {
  function verify(
    uint256 id,
    uint8 choice,
    ShipBattleData memory shipBattleData
  ) internal pure returns (ShipBattleLootTaken memory) {
    // TODO ...
    //return ShipBattleLootTaken(...);
  }

  function mutate(
    ShipBattleLootTaken memory shipBattleLootTaken,
    ShipBattleData memory shipBattleData
  ) internal pure returns (ShipBattleData memory) {
    // TODO ...
  }
}
