// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { PlayerAirdropped } from "./PlayerEvents.sol";
import { PlayerData } from "../codegen/index.sol";
import { PlayerInventoryUpdateUtil } from "./PlayerInventoryUpdateUtil.sol";

library PlayerAirdropLogic {
  error PlayerIdZero();
  error ItemIdZero();
  error QuantityZeroOrNegative(uint32 quantity);

  function verify(
    uint256 id,
    uint32 itemId,
    uint32 quantity,
    PlayerData memory playerData
  ) internal pure returns (PlayerAirdropped memory) {
    playerData.owner; // silence the warning
    if (id == 0) revert PlayerIdZero();
    if (itemId == 0) revert ItemIdZero();
    if (quantity == 0) revert QuantityZeroOrNegative(quantity);

    return PlayerAirdropped(id, itemId, quantity);
  }

  function mutate(
    PlayerAirdropped memory playerAirdropped,
    PlayerData memory playerData
  ) internal returns (PlayerData memory) {
    PlayerInventoryUpdateUtil.addOrUpdateInventory(
      playerAirdropped.id,
      playerAirdropped.itemId,
      playerAirdropped.quantity
    );

    return playerData;
  }
}
