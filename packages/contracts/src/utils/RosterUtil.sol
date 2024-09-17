// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { RosterSequenceNumber } from "../systems/RosterSequenceNumber.sol";
import { RosterId } from "../systems/RosterId.sol";

library RosterUtil {
  error RosterIsUnassignedShips();

  error PlayerIsNotRosterOwner(uint256 playerId, uint256 rosterPlayerId);

  function assertPlayerIsRosterOwner(uint256 playerId, RosterId memory rosterId) internal pure {
    if (playerId == uint256(0) || rosterId.playerId != playerId) {
      revert PlayerIsNotRosterOwner(playerId, rosterId.playerId);
    }
  }

  function isValidRosterIdSequenceNumber(uint256 rosterIdSequenceNumber) internal pure returns (bool) {
    return rosterIdSequenceNumber <= RosterSequenceNumber.FOURTH; // todo: make this dynamic
  }

  function assertRosterIsNotUnassignedShips(uint32 rosterSequenceNumber) internal pure {
    if (rosterSequenceNumber == 0) {
      revert RosterIsUnassignedShips();
    }
  }

  function addShipId(
    uint256[] memory shipIds,
    uint256 shipId,
    uint256 position
  ) internal pure returns (uint256[] memory) {
    uint256[] memory newShipIds = new uint256[](shipIds.length + 1);

    if (position >= shipIds.length) {
      for (uint256 i = 0; i < shipIds.length; i++) {
        newShipIds[i] = shipIds[i];
      }
      newShipIds[shipIds.length] = shipId;
    } else {
      for (uint256 i = 0; i < position; i++) {
        newShipIds[i] = shipIds[i];
      }
      newShipIds[position] = shipId;
      for (uint256 i = position; i < shipIds.length; i++) {
        newShipIds[i + 1] = shipIds[i];
      }
    }

    return newShipIds;
  }

  function addShipIdToEnd(uint256[] memory shipIds, uint256 shipId) internal pure returns (uint256[] memory) {
    uint256[] memory newShipIds = new uint256[](shipIds.length + 1);
    for (uint256 i = 0; i < shipIds.length; i++) {
      newShipIds[i] = shipIds[i];
    }
    newShipIds[shipIds.length] = shipId;
    return newShipIds;
  }

  function getRosterOriginCoordinates(
    uint32 islandX,
    uint32 islandY,
    uint32 rosterSeq
  ) internal pure returns (uint32 x, uint32 y) {
    x = islandX + rosterSeq * 150;
    y = islandY + 1800;
  }
}
