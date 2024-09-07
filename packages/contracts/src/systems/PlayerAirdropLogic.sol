// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerAirdropped } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";

library PlayerAirdropLogic {
  function verify(
    uint256 id,
    uint32 itemId,
    uint32 quantity,
    PlayerData memory playerData
  ) internal pure returns (PlayerAirdropped memory) {
    // TODO ...
    //return PlayerAirdropped(...);
  }

  function mutate(
    PlayerAirdropped memory playerAirdropped,
    PlayerData memory playerData
  ) internal pure returns (PlayerData memory) {
    // TODO ...
  }
}
