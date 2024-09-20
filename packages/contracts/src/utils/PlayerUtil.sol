// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { PlayerData, Player } from "../codegen/index.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

library PlayerUtil {
  error SenderIsNotPlayerOwner(address sender, address owner);

  function assertSenderIsPlayerOwner(uint256 playerId) internal view returns (PlayerData memory) {
    PlayerData memory playerData = Player.get(playerId);
    if (WorldContextConsumerLib._msgSender() != playerData.owner) {
      revert SenderIsNotPlayerOwner(WorldContextConsumerLib._msgSender(), playerData.owner);
    }
    return playerData;
  }
}
