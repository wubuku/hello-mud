// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { ShipInventoryDeducted } from "./ShipEvents.sol";
import { ShipData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

library ShipDeductShipInventoryLogic {
  function verify(
    uint256 id,
    ItemIdQuantityPair[] memory items,
    ShipData memory shipData
  ) internal pure returns (ShipInventoryDeducted memory) {
    // TODO ...
    //return ShipInventoryDeducted(...);
  }

  function mutate(
    ShipInventoryDeducted memory shipInventoryDeducted,
    ShipData memory shipData
  ) internal pure returns (ShipData memory) {
    // TODO ...
  }
}
