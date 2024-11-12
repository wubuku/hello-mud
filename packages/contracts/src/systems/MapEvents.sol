// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";

import { Coordinates } from "./Coordinates.sol";

struct MapCreated {
  bool existing;
  bool islandClaimWhitelistEnabled;
  uint32 islandResourceRenewalQuantity;
  uint64 islandResourceRenewalTime;
  uint32[] islandRenewableItemIds;
}

struct MapUpdated {
  bool existing;
  bool islandClaimWhitelistEnabled;
  uint32 islandResourceRenewalQuantity;
  uint64 islandResourceRenewalTime;
  uint32[] islandRenewableItemIds;
}

struct IslandAdded {
  /**
   * @dev The X of the Coordinates.
   */
  uint32 coordinatesX;
  /**
   * @dev The Y of the Coordinates.
   */
  uint32 coordinatesY;
  ItemIdQuantityPair[] resources;
}

struct MultiIslandsAdded {
  Coordinates[] coordinates;
  /**
   * @dev Resource item IDs of each island
   */
  uint32[] resourceItemIds;
  /**
   * @dev Resource subtotal quantity of each island
   */
  uint32 resourceSubtotal;
}

struct MapIslandClaimed {
  /**
   * @dev The X of the Coordinates.
   */
  uint32 coordinatesX;
  /**
   * @dev The Y of the Coordinates.
   */
  uint32 coordinatesY;
  /**
   * @dev The player (Id) that is claiming the island
   */
  uint256 claimedBy;
  /**
   * @dev The timestamp (unix epoch time in seconds) of the claim
   */
  uint64 claimedAt;
}

struct IslandResourcesGathered {
  uint256 playerId;
  uint64 gatheredAt;
  /**
   * @dev The X of the Coordinates.
   */
  uint32 coordinatesX;
  /**
   * @dev The Y of the Coordinates.
   */
  uint32 coordinatesY;
  ItemIdQuantityPair[] resources;
}

