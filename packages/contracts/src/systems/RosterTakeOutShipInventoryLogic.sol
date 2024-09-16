// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipInventoryTakenOut } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library RosterTakeOutShipInventoryLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    ItemIdQuantityPair[] memory itemIdQuantityPairs,
    uint32 updatedCoordinatesX,
    uint32 updatedCoordinatesY,
    RosterData memory rosterData
  ) internal pure returns (RosterShipInventoryTakenOut memory) {
    // TODO ...
    //return RosterShipInventoryTakenOut(...);
  }

  function mutate(
    RosterShipInventoryTakenOut memory rosterShipInventoryTakenOut,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    // TODO ...
  }
}
