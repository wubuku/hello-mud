// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerItemsDeducted } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library PlayerDeductItemsLogic {
  function verify(
    uint256 id,
    ItemIdQuantityPair[] memory items,
    PlayerData memory playerData
  ) internal pure returns (PlayerItemsDeducted memory) {
    // TODO ...
    //return PlayerItemsDeducted(...);
  }

  function mutate(
    PlayerItemsDeducted memory playerItemsDeducted,
    PlayerData memory playerData
  ) internal pure returns (PlayerData memory) {
    // TODO ...
  }
}
