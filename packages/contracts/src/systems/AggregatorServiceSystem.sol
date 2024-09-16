// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { EnergyToken } from "../codegen/index.sol";
import { SafeERC20, IERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract AggregatorServiceSystem is System {
  using SafeERC20 for IERC20;

  function uniApiStartCreation(
    uint8 skillProcessIdSkillType,
    uint256 skillProcessIdPlayerId,
    uint8 skillProcessIdSequenceNumber,
    uint32 batchSize,
    uint256 playerId,
    uint8 itemCreationIdSkillType,
    uint32 itemCreationIdItemId
  ) public {
    uint256 amount = 1; // TODO: Only for testing
    address tokenAddress = EnergyToken.get();
    require(tokenAddress != address(0), "Invalid token address");
    require(amount > 0, "Amount must be greater than 0");

    IERC20 token = IERC20(tokenAddress);
    // SafeERC20 处理了转账失败的情况，会自动回滚交易
    token.safeTransferFrom(_msgSender(), address(this), amount);

    // TODO ...
  }

  function uniApiStartProduction(
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

  function uniApiStartShipProduction(
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

  function uniApiRosterSetSail(
    uint256 rosterPlayerId,
    uint32 rosterSequenceNumber,
    uint256 playerId,
    int32 targetCoordinatesX,
    int32 targetCoordinatesY,
    uint64 energyAmount,
    uint64 sailDuration,
    int32 updatedCoordinatesX,
    int32 updatedCoordinatesY
  ) public {
    // TODO ...
  }
}
