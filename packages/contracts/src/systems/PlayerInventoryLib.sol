// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { PlayerInventory, PlayerInventoryCount, PlayerInventoryData } from "../codegen/index.sol";

library PlayerInventoryLib {
  function addInventory(uint256 playerId, PlayerInventoryData memory inventory) internal {
    uint64 count = PlayerInventoryCount.get(playerId);
    PlayerInventory.set(playerId, count, inventory);
    PlayerInventoryCount.set(playerId, count + 1);
  }

  function removeLastInventory(uint256 playerId) internal {
    uint64 count = PlayerInventoryCount.get(playerId);
    require(count > 0, "No inventory_ to remove");
    PlayerInventoryCount.set(playerId, count - 1);
    PlayerInventory.deleteRecord(playerId, count - 1);
  }

  function insertInventory(uint256 playerId, uint64 index, PlayerInventoryData memory inventory) internal {
    uint64 count = PlayerInventoryCount.get(playerId);
    require(index <= count, "Invalid index");

    for (uint64 i = count; i > index; i--) {
      PlayerInventory.set(playerId, i, PlayerInventory.get(playerId, i - 1));
    }

    PlayerInventory.set(playerId, index, inventory);
    PlayerInventoryCount.set(playerId, count + 1);
  }

  function removeInventory(uint256 playerId, uint64 index) internal {
    uint64 count = PlayerInventoryCount.get(playerId);
    require(index < count, "Invalid index");

    for (uint64 i = index; i < count - 1; i++) {
      PlayerInventory.set(playerId, i, PlayerInventory.get(playerId, i + 1));
    }

    PlayerInventory.deleteRecord(playerId, count - 1);
    PlayerInventoryCount.set(playerId, count - 1);
  }

  function updateInventory(uint256 playerId, uint64 index, PlayerInventoryData memory inventory) internal {
    uint64 count = PlayerInventoryCount.get(playerId);
    require(index < count, "Invalid index");
    PlayerInventory.set(playerId, index, inventory);
  }

  function truncateInventory_(uint256 playerId, uint64 newCount) internal {
    uint64 currentCount = PlayerInventoryCount.get(playerId);
    require(newCount <= currentCount, "New count must be less than or equal to current count");    
    for (uint64 i = newCount; i < currentCount; i++) {
      PlayerInventory.deleteRecord(playerId, i);
    }
    PlayerInventoryCount.set(playerId, newCount);
  }

  function updateAllInventory_(uint256 playerId, PlayerInventoryData[] memory inventory_) internal {
    uint64 currentCount = PlayerInventoryCount.get(playerId);
    for (uint64 i = 0; i < inventory_.length; i++) {
      PlayerInventory.set(playerId, i, inventory_[i]);
    }
    if (inventory_.length < currentCount) {
      for (uint256 i = inventory_.length; i < currentCount; i++) {
        PlayerInventory.deleteRecord(playerId, uint64(i));
      }
    }
    PlayerInventoryCount.set(playerId, uint64(inventory_.length));
  }

  function getAllInventory_(uint256 playerId) internal view returns (PlayerInventoryData[] memory) {
    uint64 count = PlayerInventoryCount.get(playerId);
    PlayerInventoryData[] memory inventory_ = new PlayerInventoryData[](count);
    for (uint64 i = 0; i < count; i++) {
      inventory_[i] = PlayerInventory.get(playerId, i);
    }
    return inventory_;
  }

  function getInventoryCount(uint256 playerId) internal view returns (uint64) {
    return PlayerInventoryCount.get(playerId);
  }

  function getInventoryByIndex(uint256 playerId, uint64 index) internal view returns (PlayerInventoryData memory) {
    return PlayerInventory.get(playerId, index);
  }
}
