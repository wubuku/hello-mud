// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerCreated } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";

library PlayerCreateLogic {
  function verify(
    uint256 id,
    string memory name
  ) internal pure returns (PlayerCreated memory) {
    // TODO ...
    //return PlayerCreated(...);
  }

  function mutate(
    PlayerCreated memory playerCreated
  ) internal pure returns (PlayerData memory) {
    PlayerData memory playerData;
    // TODO ...
    return playerData;
  }
}
