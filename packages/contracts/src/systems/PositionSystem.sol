// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { Position, PositionData } from "../codegen/index.sol";
import { PositionCreated, PositionUpdated } from "./PositionEvents.sol";
import { PositionCreateLogic } from "./PositionCreateLogic.sol";
import { PositionUpdateLogic } from "./PositionUpdateLogic.sol";
import { IAppSystemErrors } from "./IAppSystemErrors.sol";

contract PositionSystem is System, IAppSystemErrors {
  event PositionCreatedEvent(address indexed player, int32 x, int32 y, string description);

  event PositionUpdatedEvent(address indexed player, int32 x, int32 y, string description);

  function positionCreate(address player, int32 x, int32 y, string memory description) public {
    PositionData memory positionData = Position.get(player);
    if (!(positionData.x == int32(0) && positionData.y == int32(0) && bytes(positionData.description).length == 0)) {
      revert PositionAlreadyExists(player);
    }
    PositionCreated memory positionCreated = PositionCreateLogic.verify(player, x, y, description);
    positionCreated.player = player;
    emit PositionCreatedEvent(positionCreated.player, positionCreated.x, positionCreated.y, positionCreated.description);
    PositionData memory newPositionData = PositionCreateLogic.mutate(positionCreated);
    Position.set(player, newPositionData);
  }

  function positionUpdate(address player, int32 x, int32 y, string memory description) public {
    PositionData memory positionData = Position.get(player);
    if (positionData.x == int32(0) && positionData.y == int32(0) && bytes(positionData.description).length == 0) {
      revert PositionDoesNotExist(player);
    }
    PositionUpdated memory positionUpdated = PositionUpdateLogic.verify(player, x, y, description, positionData);
    positionUpdated.player = player;
    emit PositionUpdatedEvent(positionUpdated.player, positionUpdated.x, positionUpdated.y, positionUpdated.description);
    PositionData memory updatedPositionData = PositionUpdateLogic.mutate(positionUpdated, positionData);
    Position.set(player, updatedPositionData);
  }

}
