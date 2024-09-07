// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipInventoryTransferred } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library RosterTransferShipInventoryLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 fromShipId,
    uint256 toShipId,
    ItemIdQuantityPair[] memory itemIdQuantityPairs,
    RosterData memory rosterData
  ) internal pure returns (RosterShipInventoryTransferred memory) {
    // TODO ...
    //return RosterShipInventoryTransferred(...);
  }

  function mutate(
    RosterShipInventoryTransferred memory rosterShipInventoryTransferred,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    // TODO ...
  }
}
