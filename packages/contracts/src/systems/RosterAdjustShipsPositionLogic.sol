// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipsPositionAdjusted } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";
import { PlayerUtil } from "../utils/PlayerUtil.sol";
import { RosterUtil } from "../utils/RosterUtil.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";
import { RosterId } from "./RosterId.sol";

library RosterAdjustShipsPositionLogic {
  error ShipIdsAndPositionsLengthMismatch();
  error ShipIdNotFound(uint256 shipId);

  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint64[] memory positions,
    uint256[] memory shipIds,
    RosterData memory rosterData
  ) internal view returns (RosterShipsPositionAdjusted memory) {
    PlayerUtil.assertSenderIsPlayerOwner(playerId);
    // PlayerData memory player = Player.get(playerId);
    RosterId memory rosterId = RosterId(playerId, sequenceNumber);
    RosterUtil.assertPlayerIsRosterOwner(playerId, rosterId);

    if (shipIds.length != positions.length) {
      revert ShipIdsAndPositionsLengthMismatch();
    }

    return RosterShipsPositionAdjusted(playerId, sequenceNumber, positions, shipIds);
  }

  function mutate(
    RosterShipsPositionAdjusted memory rosterShipsPositionAdjusted,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    uint64[] memory newPositions = rosterShipsPositionAdjusted.positions;
    uint256[] memory adjustedShipIds = rosterShipsPositionAdjusted.shipIds;
    uint256[] memory rosterShipIds = rosterData.shipIds;

    for (uint i = 0; i < newPositions.length; i++) {
      uint256 shipId = adjustedShipIds[i];
      uint64 newPosition = newPositions[i];

      (uint256 oldPosition, bool found) = ShipIdUtil.findShipId(rosterShipIds, shipId);
      if (!found) {
        revert ShipIdNotFound(shipId);
      }

      if (oldPosition != newPosition) {
        // Remove the ship from its old position
        rosterShipIds = ShipIdUtil.removeShipId(rosterShipIds, shipId);
        // Add the ship to its new position
        rosterShipIds = ShipIdUtil.addShipId(rosterShipIds, shipId, newPosition);
      }
    }

    rosterData.shipIds = rosterShipIds;
    return rosterData;
  }
}
