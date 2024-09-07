// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

struct IslandAdded {
  int32 coordinatesX;
  int32 coordinatesY;
}

struct MapIslandClaimed {
  int32 coordinatesX;
  int32 coordinatesY;
  uint256 claimedBy;
  uint64 claimedAt;
}

struct IslandResourcesGathered {
  uint256 playerId;
  uint64 gatheredAt;
  int32 coordinatesX;
  int32 coordinatesY;
}

