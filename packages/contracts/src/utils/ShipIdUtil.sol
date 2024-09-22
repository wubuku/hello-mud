// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../systems/ItemIdQuantityPair.sol";
import "./SortedVectorUtil.sol";

library ShipIdUtil {
  error ShipIdNotFound(uint256 shipId);
  error EmptyShipIds();
  error InvalidShipId();

  function removeShipId(uint256[] memory shipIds, uint256 shipId) internal pure returns (uint256[] memory) {
    if (shipId == uint256(0)) {
      revert InvalidShipId();
    }
    if (shipIds.length == 0) {
      revert EmptyShipIds();
    }
    uint256[] memory newShipIds = new uint256[](shipIds.length - 1);
    uint256 j = 0;
    for (uint i = 0; i < shipIds.length; i++) {
      if (shipIds[i] != shipId) {
        newShipIds[j] = shipIds[i];
        j++;
      }
    }
    if (j == shipIds.length) revert ShipIdNotFound(shipId);
    return newShipIds;
  }

  function containsShipId(uint256[] memory shipIds, uint256 shipId) internal pure returns (bool) {
    (, bool found) = findShipId(shipIds, shipId);
    return found;
  }

  function findShipId(uint256[] memory shipIds, uint256 shipId) internal pure returns (uint256, bool) {
    for (uint i = 0; i < shipIds.length; i++) {
      if (shipIds[i] == shipId) {
        return (i, true);
      }
    }
    return (0, false);
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
    return addShipId(shipIds, shipId, shipIds.length);
  }
}
