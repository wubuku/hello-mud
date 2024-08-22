// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

struct TerrainCreated {
  int32 x;
  int32 y;
  string terrainType;
  uint8[] foo;
  bytes bar;
}

struct TerrainUpdated {
  int32 x;
  int32 y;
  string terrainType;
  uint8[] foo;
  bytes bar;
}