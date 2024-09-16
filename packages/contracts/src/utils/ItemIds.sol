// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;


//uint256 constant EInvalidSkillType = 10;
uint32 constant UNUSED_ITEM = 0;
uint32 constant RESOURCE_TYPE_WOODCUTTING = 2000000001;
uint32 constant RESOURCE_TYPE_FISHING = 2000000002;
uint32 constant RESOURCE_TYPE_MINING = 2000000003;
// uint32 constant RESOURCE_TYPE_SMITHING = 2000000004;
// uint32 constant RESOURCE_TYPE_COOKING = 2000000005;
// uint32 constant RESOURCE_TYPE_CRAFTING = 2000000006;
// uint32 constant RESOURCE_TYPE_TOWNSHIP = 2000000007;
uint32 constant SHIP = 1000000001;
uint32 constant NORMAL_LOGS = 200;
uint32 constant POTATO_SEEDS = 1;
uint32 constant POTATOES = 101;
uint32 constant COTTON_SEEDS = 2;
uint32 constant COTTONS = 102;
uint32 constant COPPER_ORE = 301;
uint32 constant TIN_ORE = 302;
uint32 constant BRONZE_BAR = 1001;

library ItemIds {
  function unusedItem() internal pure returns (uint32) {
    return UNUSED_ITEM;
  }

  function ship() internal pure returns (uint32) {
    return SHIP;
  }

  function shouldProduceIndividuals(uint32 itemId) internal pure returns (bool) {
    return itemId == SHIP;
  }

  function resourceTypeWoodcutting() internal pure returns (uint32) {
    return RESOURCE_TYPE_WOODCUTTING;
  }

  function resourceTypeFishing() internal pure returns (uint32) {
    return RESOURCE_TYPE_FISHING;
  }

  function resourceTypeMining() internal pure returns (uint32) {
    return RESOURCE_TYPE_MINING;
  }

  function resourceTypeRequiredForSkill(uint32 skillType) internal pure returns (uint32) {
    if (skillType == 1) {
      return RESOURCE_TYPE_WOODCUTTING;
    } else if (skillType == 2) {
      return RESOURCE_TYPE_FISHING;
    } else if (skillType == 3) {
      return RESOURCE_TYPE_MINING;
    } else {
      revert("Invalid skill type");
    }
  }
}
