// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { SailIntPoint, SailIntPointCount, SailIntPointData } from "../codegen/index.sol";

library SailIntPointLib {
  function addSailIntermediatePoint(uint256 playerId, uint32 sequenceNumber, SailIntPointData memory sailIntermediatePoint) internal {
    uint64 count = SailIntPointCount.get(playerId, sequenceNumber);
    SailIntPoint.set(playerId, sequenceNumber, count, sailIntermediatePoint);
    SailIntPointCount.set(playerId, sequenceNumber, count + 1);
  }

  function removeLastSailIntermediatePoint(uint256 playerId, uint32 sequenceNumber) internal {
    uint64 count = SailIntPointCount.get(playerId, sequenceNumber);
    require(count > 0, "No sailIntermediatePoints to remove");
    SailIntPointCount.set(playerId, sequenceNumber, count - 1);
    SailIntPoint.deleteRecord(playerId, sequenceNumber, count - 1);
  }

  function insertSailIntermediatePoint(uint256 playerId, uint32 sequenceNumber, uint64 index, SailIntPointData memory sailIntermediatePoint) internal {
    uint64 count = SailIntPointCount.get(playerId, sequenceNumber);
    require(index <= count, "Invalid index");

    for (uint64 i = count; i > index; i--) {
      SailIntPoint.set(playerId, sequenceNumber, i, SailIntPoint.get(playerId, sequenceNumber, i - 1));
    }

    SailIntPoint.set(playerId, sequenceNumber, index, sailIntermediatePoint);
    SailIntPointCount.set(playerId, sequenceNumber, count + 1);
  }

  function removeSailIntermediatePoint(uint256 playerId, uint32 sequenceNumber, uint64 index) internal {
    uint64 count = SailIntPointCount.get(playerId, sequenceNumber);
    require(index < count, "Invalid index");

    for (uint64 i = index; i < count - 1; i++) {
      SailIntPoint.set(playerId, sequenceNumber, i, SailIntPoint.get(playerId, sequenceNumber, i + 1));
    }

    SailIntPoint.deleteRecord(playerId, sequenceNumber, count - 1);
    SailIntPointCount.set(playerId, sequenceNumber, count - 1);
  }

  function updateSailIntermediatePoint(uint256 playerId, uint32 sequenceNumber, uint64 index, SailIntPointData memory sailIntermediatePoint) internal {
    uint64 count = SailIntPointCount.get(playerId, sequenceNumber);
    require(index < count, "Invalid index");
    SailIntPoint.set(playerId, sequenceNumber, index, sailIntermediatePoint);
  }

  function truncateSailIntermediatePoints(uint256 playerId, uint32 sequenceNumber, uint64 newCount) internal {
    uint64 currentCount = SailIntPointCount.get(playerId, sequenceNumber);
    require(newCount <= currentCount, "New count must be less than or equal to current count");    
    for (uint64 i = newCount; i < currentCount; i++) {
      SailIntPoint.deleteRecord(playerId, sequenceNumber, i);
    }
    SailIntPointCount.set(playerId, sequenceNumber, newCount);
  }

  function updateAllSailIntermediatePoints(uint256 playerId, uint32 sequenceNumber, SailIntPointData[] memory sailIntermediatePoints) internal {
    uint64 currentCount = SailIntPointCount.get(playerId, sequenceNumber);
    for (uint64 i = 0; i < sailIntermediatePoints.length; i++) {
      SailIntPoint.set(playerId, sequenceNumber, i, sailIntermediatePoints[i]);
    }
    if (sailIntermediatePoints.length < currentCount) {
      for (uint256 i = sailIntermediatePoints.length; i < currentCount; i++) {
        SailIntPoint.deleteRecord(playerId, sequenceNumber, uint64(i));
      }
    }
    SailIntPointCount.set(playerId, sequenceNumber, uint64(sailIntermediatePoints.length));
  }

  function getAllSailIntermediatePoints(uint256 playerId, uint32 sequenceNumber) internal view returns (SailIntPointData[] memory) {
    uint64 count = SailIntPointCount.get(playerId, sequenceNumber);
    SailIntPointData[] memory sailIntermediatePoints = new SailIntPointData[](count);
    for (uint64 i = 0; i < count; i++) {
      sailIntermediatePoints[i] = SailIntPoint.get(playerId, sequenceNumber, i);
    }
    return sailIntermediatePoints;
  }

  function getSailIntermediatePointCount(uint256 playerId, uint32 sequenceNumber) internal view returns (uint64) {
    return SailIntPointCount.get(playerId, sequenceNumber);
  }

  function getSailIntermediatePointByIndex(uint256 playerId, uint32 sequenceNumber, uint64 index) internal view returns (SailIntPointData memory) {
    return SailIntPoint.get(playerId, sequenceNumber, index);
  }
}
