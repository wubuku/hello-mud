// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IslandClaimed } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";
import { MapAggregateLib } from "./MapAggregateLib.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";


library PlayerClaimIslandLogic {
  function verify(
    uint256 id,
    int32 coordinatesX,
    int32 coordinatesY,
    PlayerData memory playerData
  ) internal view returns (IslandClaimed memory) {
    require(playerData.owner == WorldContextConsumerLib._msgSender(), "MsgSender is not the player.owner");

    // TODO check coordinatesX, coordinatesY

    uint64 claimedAt = uint64(block.timestamp);
    return IslandClaimed(id, coordinatesX, coordinatesY, claimedAt);
  }

  function mutate(
    IslandClaimed memory islandClaimed,
    PlayerData memory playerData
  ) internal returns (PlayerData memory) {
    int32 coordinatesX = islandClaimed.coordinatesX;
    int32 coordinatesY = islandClaimed.coordinatesY;
    uint64 claimedAt = islandClaimed.claimedAt;
    uint256 claimedBy = islandClaimed.id; // Player ID
    MapAggregateLib.claimIsland(coordinatesX, coordinatesY, claimedBy, claimedAt);
    // TODO ...
  }
}
