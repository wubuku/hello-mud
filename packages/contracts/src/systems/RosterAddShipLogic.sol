// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipAdded } from "./RosterEvents.sol";
import { RosterData, Roster } from "../codegen/index.sol";
import { ShipIdUtil } from "../utils/ShipIdUtil.sol";

library RosterAddShipLogic {
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    uint64 position,
    RosterData memory rosterData
  ) internal view returns (RosterShipAdded memory) {
    return RosterShipAdded(playerId, sequenceNumber, shipId, position);
  }

  function mutate(
    RosterShipAdded memory rosterShipAdded,
    RosterData memory rosterData
  ) internal view returns (RosterData memory) {
    uint256 shipId = rosterShipAdded.shipId;
    uint256[] memory shipIds = rosterData.shipIds;
    shipIds = ShipIdUtil.addShipId(shipIds, shipId, rosterShipAdded.position);
    rosterData.shipIds = shipIds;
    return rosterData;
  }
}
