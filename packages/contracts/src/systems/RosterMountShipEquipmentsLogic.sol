// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { RosterShipEquipmentsMounted } from "./RosterEvents.sol";
import { RosterData } from "../codegen/index.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
//import { WorldContextConsumerLib } from "@latticexyz/world/src/WorldContext.sol";
//import { SailIntPointData } from "../codegen/index.sol";
//import { SailIntPointLib } from "./SailIntPointLib.sol";
// You may need to use the SailIntPointLib library to access and modify the state (SailIntPointData) of the SailIntPoint entity within the Roster aggregate
//import { SailIntPoint } from "../codegen/index.sol";
// You may also need to use the SailIntPoint library to access the state of the SailIntPoint entity within the Roster aggregate

//import { ShipMountingPositions } from "./ShipMountingPositions.sol";
// You may need to use constants in the ShipMountingPositions library


/**
 * @title RosterMountShipEquipmentsLogic Library
 * @dev Implements the Roster.MountShipEquipments method.
 */
library RosterMountShipEquipmentsLogic {
  /**
   * @notice Verifies the Roster.MountShipEquipments command.
   * @param rosterData The current state the Roster.
   * @return A RosterShipEquipmentsMounted event struct.
   */
  function verify(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 shipId,
    uint8 mountingPosition,
    ItemIdQuantityPair[] memory equipments,
    RosterData memory rosterData
  ) internal pure returns (RosterShipEquipmentsMounted memory) {
    // If necessary, change state mutability modifier of the function from `pure` to `view` or just delete `pure`.
    //
    // Note: Do not arbitrarily add parameters to functions or fields to structs.
    //
    // The message sender can be obtained like this: `WorldContextConsumerLib._msgSender()`
    //
    // TODO: Check arguments, throw if illegal.
    /*
    return RosterShipEquipmentsMounted({
      playerId: // type: uint256. The PlayerId of the RosterId.
      sequenceNumber: // type: uint32. The SequenceNumber of the RosterId.
      shipId: // type: uint256
      mountingPosition: // type: uint8
      equipments: // type: ItemIdQuantityPair[]
    });
    */
  }

  /**
   * @notice Performs the state mutation operation of Roster.MountShipEquipments method.
   * @dev This function is called after verification to update the Roster's state.
   * @param rosterShipEquipmentsMounted The RosterShipEquipmentsMounted event struct from the verify function.
   * @param rosterData The current state of the Roster.
   * @return The new state of the Roster.
   */
  function mutate(
    RosterShipEquipmentsMounted memory rosterShipEquipmentsMounted,
    RosterData memory rosterData
  ) internal pure returns (RosterData memory) {
    // If necessary, change state mutability modifier of the function from `pure` to `view` or just delete `pure`.

    // NOTE: The SailIntPoint entity is managed separately.
    // The actual storage of the SailIntPoint (SailIntPointData) would be handled by the SailIntPointLib library.
    // Note: Functions cannot be declared as pure or view if you modify the state of the SailIntPoint entity.

    //
    // The fields (types and names) of the struct SailIntPointData:
    //   uint32 coordinatesX // The CoordinatesX of the SailIntermediatePoint.
    //   uint32 coordinatesY // The CoordinatesY of the SailIntermediatePoint.
    //   uint64 segmentShouldStartAt // The SegmentShouldStartAt of the SailIntermediatePoint.
    //

    //
    // The fields (types and names) of the struct RosterData:
    //   uint8 status
    //   uint32 speed
    //   uint32 baseExperience // The base experience value gained by the player when the roster is destroyed
    //   bool environmentOwned // Whether the roster is owned by the environment
    //   uint32 updatedCoordinatesX // The X of the UpdatedCoordinates. UpdatedCoordinates: The last updated coordinates
    //   uint32 updatedCoordinatesY // The Y of the UpdatedCoordinates. UpdatedCoordinates: The last updated coordinates
    //   uint64 coordinatesUpdatedAt
    //   uint32 targetCoordinatesX // The X of the TargetCoordinates.
    //   uint32 targetCoordinatesY // The Y of the TargetCoordinates.
    //   uint32 originCoordinatesX // The X of the OriginCoordinates.
    //   uint32 originCoordinatesY // The Y of the OriginCoordinates.
    //   uint64 sailDuration
    //   uint64 setSailAt
    //   uint16 currentSailSegment // The current sail segment index, starting from 0
    //   uint256 shipBattleId
    //   uint256[] shipIds
    //

    // TODO: update state properties...
    //rosterData.{STATE_PROPERTY} = rosterShipEquipmentsMounted.{EVENT_PROPERTY};
    return rosterData;
  }
}
