// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { EnvironmentRosterCreated } from "./RosterEvents.sol";
import { RosterData, ShipData } from "../codegen/index.sol";
import { RosterStatus } from "./RosterStatus.sol";
import { ItemIdQuantityPair } from "../systems/ItemIdQuantityPair.sol";
import { ShipUtil } from "../utils/ShipUtil.sol";
import { TsRandomUtil } from "../utils/TsRandomUtil.sol";
import { ShipDelegatecallLib } from "./ShipDelegatecallLib.sol";
import { SortedVectorUtil } from "../utils/SortedVectorUtil.sol";
import { COPPER_ORE, NORMAL_LOGS, COTTONS, SMALL_SHIP } from "../utils/ItemIds.sol";

library RosterCreateEnvironmentRosterLogic {
  error InvalidShipResourceQuantity(uint32 shipResourceQuantity, uint32 shipBaseResourceQuantity);
  error InvalidShipBaseResourceQuantity(uint32 shipBaseResourceQuantity);

  uint32 private constant DEFAULT_NUMBER_OF_SHIPS = 4;

  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint32 coordinatesX,
    uint32 coordinatesY,
    uint32 shipResourceQuantity,
    uint32 shipBaseResourceQuantity,
    uint32 baseExperience
  ) internal pure returns (EnvironmentRosterCreated memory) {
    if (shipResourceQuantity < shipBaseResourceQuantity * 3) {
      revert InvalidShipResourceQuantity(shipResourceQuantity, shipBaseResourceQuantity);
    }
    if (shipBaseResourceQuantity == 0) {
      revert InvalidShipBaseResourceQuantity(shipBaseResourceQuantity);
    }

    return
      EnvironmentRosterCreated({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        coordinatesX: coordinatesX,
        coordinatesY: coordinatesY,
        shipResourceQuantity: shipResourceQuantity,
        shipBaseResourceQuantity: shipBaseResourceQuantity,
        baseExperience: baseExperience
      });
  }

  function mutate(EnvironmentRosterCreated memory environmentRosterCreated) internal returns (RosterData memory) {
    RosterData memory rosterData;
    rosterData.status = uint8(RosterStatus.AT_ANCHOR);
    rosterData.updatedCoordinatesX = environmentRosterCreated.coordinatesX;
    rosterData.updatedCoordinatesY = environmentRosterCreated.coordinatesY;
    rosterData.coordinatesUpdatedAt = uint64(block.timestamp);
    rosterData.targetCoordinatesX = environmentRosterCreated.coordinatesX;
    rosterData.targetCoordinatesY = environmentRosterCreated.coordinatesX;
    rosterData.originCoordinatesX = environmentRosterCreated.coordinatesX;
    rosterData.originCoordinatesY = environmentRosterCreated.coordinatesY;
    rosterData.baseExperience = environmentRosterCreated.baseExperience;
    rosterData.environmentOwned = true;

    uint256 playerId = environmentRosterCreated.playerId;
    uint32 rosterSeqNumber = environmentRosterCreated.sequenceNumber;

    uint32 totalRosterSpeed = 0;
    uint256[] memory shipIds = new uint256[](DEFAULT_NUMBER_OF_SHIPS);

    for (uint32 position = 0; position < DEFAULT_NUMBER_OF_SHIPS; position++) {
      bytes memory randSeed = abi.encodePacked(playerId, rosterSeqNumber, position);

      uint32 currentResourceQuantity = environmentRosterCreated.shipResourceQuantity;
      uint64[] memory randomResourceQuantities = TsRandomUtil.divideInt(
        randSeed,
        currentResourceQuantity - environmentRosterCreated.shipBaseResourceQuantity * 3,
        3
      );
      uint32[] memory buildingExpensesItemIds = new uint32[](3);
      uint32[] memory buildingExpensesQuantities = new uint32[](3);
      buildingExpensesItemIds[0] = COPPER_ORE;
      buildingExpensesQuantities[0] =
        environmentRosterCreated.shipBaseResourceQuantity +
        uint32(randomResourceQuantities[0]);
      buildingExpensesItemIds[1] = NORMAL_LOGS;
      buildingExpensesQuantities[1] =
        environmentRosterCreated.shipBaseResourceQuantity +
        uint32(randomResourceQuantities[1]);
      buildingExpensesItemIds[2] = COTTONS;
      buildingExpensesQuantities[2] =
        environmentRosterCreated.shipBaseResourceQuantity +
        uint32(randomResourceQuantities[2]);

      ItemIdQuantityPair[] memory buildingExpenses = SortedVectorUtil.newItemIdQuantityPairs(
        buildingExpensesItemIds,
        buildingExpensesQuantities
      );

      (uint32 healthPoints, uint32 attack, uint32 protection, uint32 shipSpeed) = ShipUtil.calculateShipAttributes(
        buildingExpenses
      );

      uint256 shipId = ShipDelegatecallLib.create(
        SMALL_SHIP,
        playerId,
        rosterSeqNumber,
        healthPoints,
        attack,
        protection,
        shipSpeed,
        buildingExpensesItemIds,
        buildingExpensesQuantities
      );

      shipIds[position] = shipId;
      totalRosterSpeed += shipSpeed;
    }

    rosterData.shipIds = shipIds;
    rosterData.speed = totalRosterSpeed / DEFAULT_NUMBER_OF_SHIPS;
    rosterData.sailDuration = 0;
    rosterData.setSailAt = 0;
    rosterData.shipBattleId = 0;

    return rosterData;
  }
}
