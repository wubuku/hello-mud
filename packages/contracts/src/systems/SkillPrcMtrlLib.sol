// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { SkillPrcMtrl, SkillPrcMtrlCount, SkillPrcMtrlData } from "../codegen/index.sol";

library SkillPrcMtrlLib {
  function addProductionMaterial(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber, SkillPrcMtrlData memory productionMaterial) internal {
    uint64 count = SkillPrcMtrlCount.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber);
    SkillPrcMtrl.set(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, count, productionMaterial);
    SkillPrcMtrlCount.set(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, count + 1);
  }

  function removeLastProductionMaterial(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber) internal {
    uint64 count = SkillPrcMtrlCount.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber);
    require(count > 0, "No productionMaterials to remove");
    SkillPrcMtrlCount.set(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, count - 1);
    SkillPrcMtrl.deleteRecord(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, count - 1);
  }

  function insertProductionMaterial(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber, uint64 index, SkillPrcMtrlData memory productionMaterial) internal {
    uint64 count = SkillPrcMtrlCount.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber);
    require(index <= count, "Invalid index");

    for (uint64 i = count; i > index; i--) {
      SkillPrcMtrl.set(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, i, SkillPrcMtrl.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, i - 1));
    }

    SkillPrcMtrl.set(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, index, productionMaterial);
    SkillPrcMtrlCount.set(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, count + 1);
  }

  function removeProductionMaterial(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber, uint64 index) internal {
    uint64 count = SkillPrcMtrlCount.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber);
    require(index < count, "Invalid index");

    for (uint64 i = index; i < count - 1; i++) {
      SkillPrcMtrl.set(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, i, SkillPrcMtrl.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, i + 1));
    }

    SkillPrcMtrl.deleteRecord(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, count - 1);
    SkillPrcMtrlCount.set(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, count - 1);
  }

  function updateProductionMaterial(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber, uint64 index, SkillPrcMtrlData memory productionMaterial) internal {
    uint64 count = SkillPrcMtrlCount.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber);
    require(index < count, "Invalid index");
    SkillPrcMtrl.set(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, index, productionMaterial);
  }

  function getAllProductionMaterials(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber) internal view returns (SkillPrcMtrlData[] memory) {
    uint64 count = SkillPrcMtrlCount.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber);
    SkillPrcMtrlData[] memory productionMaterials = new SkillPrcMtrlData[](count);
    for (uint64 i = 0; i < count; i++) {
      productionMaterials[i] = SkillPrcMtrl.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, i);
    }
    return productionMaterials;
  }

  function getProductionMaterialCount(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber) internal view returns (uint64) {
    return SkillPrcMtrlCount.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber);
  }

  function getProductionMaterialByIndex(uint8 skillProcessIdSkillType, uint256 skillProcessIdPlayerId, uint8 skillProcessIdSequenceNumber, uint64 index) internal view returns (SkillPrcMtrlData memory) {
    return SkillPrcMtrl.get(skillProcessIdSkillType, skillProcessIdPlayerId, skillProcessIdSequenceNumber, index);
  }
}
