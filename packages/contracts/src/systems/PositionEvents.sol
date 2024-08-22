// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

struct PositionCreated {
  address player;
  int32 x;
  int32 y;
  string description;
}

struct PositionUpdated {
  address player;
  int32 x;
  int32 y;
  string description;
}
