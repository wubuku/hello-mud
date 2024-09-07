// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipInventoryPutIn } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library RosterPutInShipInventoryLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    ItemIdQuantityPair[] memory itemIdQuantityPairs,
    int32 updatedCoordinatesX,
    int32 updatedCoordinatesY,
    RosterData memory rosterData
  ) internal pure returns (RosterShipInventoryPutIn memory) {
    // TODO ...
    //return RosterShipInventoryPutIn(...);
  }

  function mutate(
    RosterShipInventoryPutIn memory rosterShipInventoryPutIn,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    // TODO ...
  }
}
