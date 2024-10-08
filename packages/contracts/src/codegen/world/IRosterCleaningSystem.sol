// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { RosterCleanUpBattleResult } from "../../systems/RosterCleanUpBattleResult.sol";

/**
 * @title IRosterCleaningSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IRosterCleaningSystem {
  function app__rosterCleanUpBattleDestroyedShips(
    uint256 playerId,
    uint32 sequenceNumber,
    uint256 loserRosterIdPlayerId,
    uint32 loserRosterIdSequenceNumber,
    uint8 choice
  ) external returns (RosterCleanUpBattleResult memory);
}
