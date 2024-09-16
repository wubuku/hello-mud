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
    uint32 initiatorCoordinatesX,
    uint32 initiatorCoordinatesY,
    uint32 responderCoordinatesX,
    uint32 responderCoordinatesY
  ) internal pure returns (ShipBattleInitiated memory) {
    // TODO ...
    return ShipBattleInitiated(
      id,
      playerId,
      initiatorRosterPlayerId,
      initiatorRosterSequenceNumber,
      responderRosterPlayerId,
      responderRosterSequenceNumber,
      initiatorCoordinatesX,
      initiatorCoordinatesY,
      responderCoordinatesX,
      responderCoordinatesY,
      0, //startedAt,
      0, //firstRoundMover,
      0, //firstRoundAttackerShip,
      0 //firstRoundDefenderShip
    );
  }

  function mutate(ShipBattleInitiated memory shipBattleInitiated) internal pure returns (ShipBattleData memory) {
    ShipBattleData memory shipBattleData;
    shipBattleData.initiatorRosterPlayerId = shipBattleInitiated.initiatorRosterPlayerId;
    shipBattleData.initiatorRosterSequenceNumber = shipBattleInitiated.initiatorRosterSequenceNumber;
    shipBattleData.responderRosterPlayerId = shipBattleInitiated.responderRosterPlayerId;
    shipBattleData.responderRosterSequenceNumber = shipBattleInitiated.responderRosterSequenceNumber;
    shipBattleData.status = 1; //TODO ...
    shipBattleData.endedAt = 0;
    shipBattleData.winner = 0;
    shipBattleData.roundNumber = 0;
    shipBattleData.roundStartedAt = 0;
    shipBattleData.roundMover = 0;
    // TODO ...
    return shipBattleData;
  }
}
