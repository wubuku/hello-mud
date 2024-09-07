// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipBattleInitiated } from "./ShipBattleEvents.sol";
import { ShipBattleData } from "../codegen/index.sol";

library ShipBattleInitiateBattleLogic {
  function verify(
    uint256 id,
    uint256 playerId,
    uint256 initiatorRosterPlayerId,
    uint32 initiatorRosterSequenceNumber,
    uint256 responderRosterPlayerId,
    uint32 responderRosterSequenceNumber,
    int32 initiatorCoordinatesX,
    int32 initiatorCoordinatesY,
    int32 responderCoordinatesX,
    int32 responderCoordinatesY
  ) internal pure returns (ShipBattleInitiated memory) {
    // TODO ...
    //return ShipBattleInitiated(...);
  }

  function mutate(
    ShipBattleInitiated memory shipBattleInitiated
  ) internal pure returns (ShipBattleData memory) {
    ShipBattleData memory shipBattleData;
    // TODO ...
    return shipBattleData;
  }
}
