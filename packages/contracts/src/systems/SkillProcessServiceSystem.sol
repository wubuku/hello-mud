// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { SafeERC20, IERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract SkillProcessServiceSystem is System {
  using SafeERC20 for IERC20;

  function skillProcessServiceStartCreation(
    IERC20 token, // TODO For testing, remove later
    uint8 skillProcessIdSkillType,
    uint256 skillProcessIdPlayerId,
    uint8 skillProcessIdSequenceNumber,
    uint32 batchSize,
    uint256 playerId,
    uint8 itemCreationIdSkillType,
    uint32 itemCreationIdItemId
  ) public {
    uint256 amount = 1; // For testing
    require(address(token) != address(0), "Invalid token address");
    require(amount > 0, "Amount must be greater than 0");

    // SafeERC20 处理了转账失败的情况，会自动回滚交易
    token.safeTransferFrom(_msgSender(), address(this), amount);

    // TODO ...
  }

  function skillProcessServiceStartProduction(
    uint8 skillProcessIdSkillType,
    uint256 skillProcessIdPlayerId,
    uint8 skillProcessIdSequenceNumber,
    uint32 batchSize,
    uint256 playerId,
    uint8 itemProductionIdSkillType,
    uint32 itemProductionIdItemId
  ) public {
    // TODO ...
  }

  function skillProcessServiceStartShipProduction(
    uint8 skillProcessIdSkillType,
    uint256 skillProcessIdPlayerId,
    uint8 skillProcessIdSequenceNumber,
    ItemIdQuantityPair[] memory productionMaterials,
    uint256 playerId,
    uint8 itemProductionIdSkillType,
    uint32 itemProductionIdItemId
  ) public {
    // TODO ...
  }
}
