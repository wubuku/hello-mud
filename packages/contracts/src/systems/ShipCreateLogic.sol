// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipCreated } from "./ShipEvents.sol";
import { ShipData } from "../codegen/index.sol";

library ShipCreateLogic {
  function verify(
    uint256 id,
    uint32 shipItemId,
    uint256 rosterIdPlayerId,
    uint32 rosterIdSequenceNumber,
    uint32 healthPoints,
    uint32 attack,
    uint32 protection,
    uint32 speed,
    uint32[] memory buildingExpensesItemIds,
    uint32[] memory buildingExpensesQuantities
  ) internal pure returns (ShipCreated memory) {
    return ShipCreated(id, shipItemId, rosterIdPlayerId, rosterIdSequenceNumber, healthPoints, attack, protection, speed, buildingExpensesItemIds, buildingExpensesQuantities);
  }

  function mutate(
    ShipCreated memory shipCreated
  ) internal pure returns (ShipData memory) {
    ShipData memory shipData;
    shipData.playerId = shipCreated.rosterIdPlayerId;
    shipData.rosterSequenceNumber = shipCreated.rosterIdSequenceNumber;
    shipData.healthPoints = shipCreated.healthPoints;
    shipData.attack = shipCreated.attack;
    shipData.protection = shipCreated.protection;
    shipData.speed = shipCreated.speed;
    shipData.buildingExpensesItemIds = shipCreated.buildingExpensesItemIds;
    shipData.buildingExpensesQuantities = shipCreated.buildingExpensesQuantities;
    return shipData;
  }
}
