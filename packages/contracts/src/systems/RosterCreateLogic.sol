// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterCreated } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";
import { RosterStatus } from "./RosterStatus.sol";

library RosterCreateLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint32 coordinatesX,
    uint32 coordinatesY
  ) internal pure returns (RosterCreated memory) {
    return
      RosterCreated({
        playerId: playerId,
        sequenceNumber: sequenceNumber,
        coordinatesX: coordinatesX,
        coordinatesY: coordinatesY
      });
  }

  function mutate(RosterCreated memory rosterCreated) internal view returns (RosterData memory) {
    RosterData memory rosterData;
    rosterData.status = RosterStatus.AT_ANCHOR;
    // rosterData.speed = rosterCreated.speed;
    // rosterData.baseExperience = rosterCreated.baseExperience;
    // rosterData.environmentOwned = rosterCreated.environmentOwned;
    rosterData.updatedCoordinatesX = rosterCreated.coordinatesX;
    rosterData.updatedCoordinatesY = rosterCreated.coordinatesY;
    rosterData.coordinatesUpdatedAt = uint64(block.timestamp);
    rosterData.targetCoordinatesX = 0; //rosterCreated.targetCoordinatesX;
    rosterData.targetCoordinatesY = 0; //rosterCreated.targetCoordinatesY;
    rosterData.originCoordinatesX = rosterCreated.coordinatesX;
    rosterData.originCoordinatesY = rosterCreated.coordinatesY;
    // rosterData.sailDuration = rosterCreated.sailDuration;
    // rosterData.setSailAt = rosterCreated.setSailAt;
    // rosterData.shipBattleId = rosterCreated.shipBattleId;
    rosterData.shipIds = new uint256[](0);

    return rosterData;
  }
}
