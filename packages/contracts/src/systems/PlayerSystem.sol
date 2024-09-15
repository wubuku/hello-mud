// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { Player, PlayerData, PlayerIdGenerator } from "../codegen/index.sol";
import { PlayerCreated, IslandClaimed, PlayerAirdropped, PlayerIslandResourcesGathered } from "./PlayerEvents.sol";
import { PlayerCreateLogic } from "./PlayerCreateLogic.sol";
import { PlayerClaimIslandLogic } from "./PlayerClaimIslandLogic.sol";
import { PlayerAirdropLogic } from "./PlayerAirdropLogic.sol";
import { PlayerGatherIslandResourcesLogic } from "./PlayerGatherIslandResourcesLogic.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { AccessControl } from "@latticexyz/world/src/AccessControl.sol";

contract PlayerSystem is System {
  event PlayerCreatedEvent(uint256 indexed id, string name, address owner);

  event IslandClaimedEvent(uint256 indexed id, int32 coordinatesX, int32 coordinatesY, uint64 claimedAt);

  event PlayerAirdroppedEvent(uint256 indexed id, uint32 itemId, uint32 quantity);

  event PlayerIslandResourcesGatheredEvent(uint256 indexed id);

  function _requireOwner() internal view {
    AccessControl.requireOwner(SystemRegistry.get(address(this)), _msgSender());
  }

  function playerCreate(string memory name) public {
    uint256 id = PlayerIdGenerator.get() + 1;
    PlayerIdGenerator.set(id);
    PlayerData memory playerData = Player.get(id);
    require(
      playerData.owner == address(0) && playerData.level == uint16(0) && playerData.experience == uint32(0) && playerData.claimedIslandX == int32(0) && playerData.claimedIslandY == int32(0) && bytes(playerData.name).length == 0,
      "Player already exists"
    );
    PlayerCreated memory playerCreated = PlayerCreateLogic.verify(id, name);
    playerCreated.id = id;
    emit PlayerCreatedEvent(playerCreated.id, playerCreated.name, playerCreated.owner);
    PlayerData memory newPlayerData = PlayerCreateLogic.mutate(playerCreated);
    Player.set(id, newPlayerData);
  }

  function playerClaimIsland(uint256 id, int32 coordinatesX, int32 coordinatesY) public {
    PlayerData memory playerData = Player.get(id);
    require(
      !(playerData.owner == address(0) && playerData.level == uint16(0) && playerData.experience == uint32(0) && playerData.claimedIslandX == int32(0) && playerData.claimedIslandY == int32(0) && bytes(playerData.name).length == 0),
      "Player does not exist"
    );
    IslandClaimed memory islandClaimed = PlayerClaimIslandLogic.verify(id, coordinatesX, coordinatesY, playerData);
    islandClaimed.id = id;
    emit IslandClaimedEvent(islandClaimed.id, islandClaimed.coordinatesX, islandClaimed.coordinatesY, islandClaimed.claimedAt);
    PlayerData memory updatedPlayerData = PlayerClaimIslandLogic.mutate(islandClaimed, playerData);
    Player.set(id, updatedPlayerData);
  }

  function playerAirdrop(uint256 id, uint32 itemId, uint32 quantity) public {
    _requireOwner();
    PlayerData memory playerData = Player.get(id);
    require(
      !(playerData.owner == address(0) && playerData.level == uint16(0) && playerData.experience == uint32(0) && playerData.claimedIslandX == int32(0) && playerData.claimedIslandY == int32(0) && bytes(playerData.name).length == 0),
      "Player does not exist"
    );
    PlayerAirdropped memory playerAirdropped = PlayerAirdropLogic.verify(id, itemId, quantity, playerData);
    playerAirdropped.id = id;
    emit PlayerAirdroppedEvent(playerAirdropped.id, playerAirdropped.itemId, playerAirdropped.quantity);
    PlayerData memory updatedPlayerData = PlayerAirdropLogic.mutate(playerAirdropped, playerData);
    Player.set(id, updatedPlayerData);
  }

  function playerGatherIslandResources(uint256 id) public {
    PlayerData memory playerData = Player.get(id);
    require(
      !(playerData.owner == address(0) && playerData.level == uint16(0) && playerData.experience == uint32(0) && playerData.claimedIslandX == int32(0) && playerData.claimedIslandY == int32(0) && bytes(playerData.name).length == 0),
      "Player does not exist"
    );
    PlayerIslandResourcesGathered memory playerIslandResourcesGathered = PlayerGatherIslandResourcesLogic.verify(id, playerData);
    playerIslandResourcesGathered.id = id;
    emit PlayerIslandResourcesGatheredEvent(playerIslandResourcesGathered.id);
    PlayerData memory updatedPlayerData = PlayerGatherIslandResourcesLogic.mutate(playerIslandResourcesGathered, playerData);
    Player.set(id, updatedPlayerData);
  }

}
