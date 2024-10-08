// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ItemIdQuantityPair } from "../../systems/ItemIdQuantityPair.sol";
import { UpdateLocationParams } from "../../systems/UpdateLocationParams.sol";
import { Coordinates } from "../../systems/Coordinates.sol";

/**
 * @title IAggregatorServiceSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IAggregatorServiceSystem {
  error InvalidTokenAddress(address tokenAddress);
  error InvalidEnergyAmount(uint256 energyCost);
  error InsufficientEnergy(uint256 requiredEnergy, uint256 providedEnergy);

  function app__uniApiStartCreation(
    uint8 skillType,
    uint256 playerId,
    uint8 skillProcessSequenceNumber,
    uint32 itemId,
    uint32 batchSize
  ) external;

  function app__uniApiStartProduction(
    uint8 skillType,
    uint256 playerId,
    uint8 skillProcessSequenceNumber,
    uint32 itemId,
    uint32 batchSize
  ) external;

  function app__uniApiStartShipProduction(
    uint8 skillType,
    uint256 playerId,
    uint8 skillProcessSequenceNumber,
    uint32 itemId,
    ItemIdQuantityPair[] memory productionMaterials
  ) external;

  function app__uniApiRosterSetSail(
    uint256 playerId,
    uint32 rosterSequenceNumber,
    uint32 targetCoordinatesX,
    uint32 targetCoordinatesY,
    uint64 energyAmount,
    uint64 sailDuration,
    UpdateLocationParams memory updateLocationParams,
    Coordinates[] memory intermediatePoints
  ) external;

  function app__uniApiRosterUpdateLocation(
    uint256 playerId,
    uint32 rosterSequenceNumber,
    UpdateLocationParams memory updateLocationParams
  ) external;
}
