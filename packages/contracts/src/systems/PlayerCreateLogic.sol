// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerCreated } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";
import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";

library PlayerCreateLogic {
  function verify(
    uint256 id,
    string memory name
  ) internal view returns (PlayerCreated memory) {
    address playerOwner = WorldContextConsumerLib._msgSender();
    require(playerOwner != address(0), "Invalid msg sender");
    return PlayerCreated(id, name, playerOwner);
  }

  function mutate(
    PlayerCreated memory playerCreated
  ) internal pure returns (PlayerData memory) {
    PlayerData memory playerData;
    playerData.name = playerCreated.name;
    playerData.owner = playerCreated.owner;
    playerData.level = 1;
    playerData.experience = 0;
    return playerData;
  }
}
