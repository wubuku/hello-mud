// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { RosterSequenceNumber } from "../systems/RosterSequenceNumber.sol";
import { RosterDataInstance } from "./RosterDataInstance.sol";
import { RosterData, Roster } from "../codegen/index.sol";
import { RosterUtil } from "./RosterUtil.sol";
import { SpeedUtil } from "./SpeedUtil.sol";
import { RosterStatus } from "../systems/RosterStatus.sol";
import { Coordinates } from "../systems/Coordinates.sol";

library RosterSailUtil {
  using RosterDataInstance for RosterData;

  uint256 private constant ENERGY_AMOUNT_PER_SECOND_PER_SHIP = 1388889;

  error RosterUnfitToSail(uint8 status);
  error InvalidUpdatedCoordinates(uint32 updatedCoordinatesX, uint32 updatedCoordinatesY);
  //error IllegalSailDuration(uint64 totalTime, uint64 sailDuration);

  function calculateEnergyCost(
    uint256 playerId,
    uint32 rosterSequenceNumber,
    //uint32 targetCoordinatesX,
    //uint32 targetCoordinatesY,
    uint64 sailDuration
  )
    internal
    view
    returns (
      //uint32 updatedCoordinatesX,
      //uint32 updatedCoordinatesY
      uint256
    )
  {
    //, uint32, uint32
    RosterUtil.assertRosterIsNotUnassignedShips(rosterSequenceNumber);
    RosterData memory rosterData = Roster.get(playerId, rosterSequenceNumber);
    rosterData.assertRosterShipsNotEmpty();

    // uint32 newUpdatedCoordinatesX;
    // uint32 newUpdatedCoordinatesY;
    // uint8 status = rosterData.status;
    // if (status == uint8(RosterStatus.AT_ANCHOR)) {
    //   newUpdatedCoordinatesX = rosterData.updatedCoordinatesX;
    //   newUpdatedCoordinatesY = rosterData.updatedCoordinatesY;
    // } else if (status == uint8(RosterStatus.UNDERWAY)) {
    //   (bool updatable, uint64 _coordinatesUpdatedAt, uint8 _newStatus) = rosterData.isCurrentLocationUpdatable(
    //     uint64(block.timestamp),
    //     updatedCoordinatesX,
    //     updatedCoordinatesY
    //   );
    //   if (updatable) {
    //     newUpdatedCoordinatesX = updatedCoordinatesX;
    //     newUpdatedCoordinatesY = updatedCoordinatesY;
    //   } else {
    //     revert InvalidUpdatedCoordinates(updatedCoordinatesX, updatedCoordinatesY);
    //   }
    // } else {
    //   revert RosterUnfitToSail(status);
    // }

    // uint64 totalTime = SpeedUtil.calculateDirectRouteDuration(
    //   Coordinates(newUpdatedCoordinatesX, newUpdatedCoordinatesY),
    //   Coordinates(targetCoordinatesX, targetCoordinatesY),
    //   rosterData.speed
    // );

    // if (sailDuration < totalTime) {
    //   revert IllegalSailDuration(totalTime, sailDuration);
    // }
    uint256 shipCount = rosterData.shipIds.length;
    uint256 requiredEnergy = sailDuration * shipCount * ENERGY_AMOUNT_PER_SECOND_PER_SHIP;
    return requiredEnergy; //, newUpdatedCoordinatesX, newUpdatedCoordinatesY);
  }
}
