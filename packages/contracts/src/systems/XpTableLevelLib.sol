// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { XpTableLevel, XpTableLevelCount, XpTableLevelData } from "../codegen/index.sol";

library XpTableLevelLib {
  function addLevel(XpTableLevelData memory level) internal {
    uint64 count = XpTableLevelCount.get();
    XpTableLevel.set(count, level);
    XpTableLevelCount.set(count + 1);
  }

  function removeLastLevel() internal {
    uint64 count = XpTableLevelCount.get();
    require(count > 0, "No levels to remove");
    XpTableLevelCount.set(count - 1);
    XpTableLevel.deleteRecord(count - 1);
  }

  function insertLevel(uint64 index, XpTableLevelData memory level) internal {
    uint64 count = XpTableLevelCount.get();
    require(index <= count, "Invalid index");

    for (uint64 i = count; i > index; i--) {
      XpTableLevel.set(i, XpTableLevel.get(i - 1));
    }

    XpTableLevel.set(index, level);
    XpTableLevelCount.set(count + 1);
  }

  function removeLevel(uint64 index) internal {
    uint64 count = XpTableLevelCount.get();
    require(index < count, "Invalid index");

    // Shift levels after the removed one
    for (uint64 i = index; i < count - 1; i++) {
      XpTableLevel.set(i, XpTableLevel.get(i + 1));
    }

    // Delete the last level and decrease the count
    XpTableLevel.deleteRecord(count - 1);
    XpTableLevelCount.set(count - 1);
  }

  function updateLevel(uint64 index, XpTableLevelData memory level) internal {
    uint64 count = XpTableLevelCount.get();
    require(index < count, "Invalid index");
    XpTableLevel.set(index, level);
  }

  function getAllLevels() internal view returns (XpTableLevelData[] memory) {
    uint64 count = XpTableLevelCount.get();
    XpTableLevelData[] memory levels = new XpTableLevelData[](count);
    for (uint64 i = 0; i < count; i++) {
      levels[i] = XpTableLevel.get(i);
    }
    return levels;
  }
}
