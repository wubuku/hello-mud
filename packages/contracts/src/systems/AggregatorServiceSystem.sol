// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { System } from "@latticexyz/world/src/System.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { EnergyToken } from "../codegen/index.sol";
import { SafeERC20, IERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { SkillProcessDelegationLib } from "./SkillProcessDelegationLib.sol";

contract AggregatorServiceSystem is System {
  using SafeERC20 for IERC20;

  function uniApiStartCreation(
    uint8 skillType,
    uint256 playerId,
    uint8 skillProcessSequenceNumber,
    uint32 itemId,
    uint32 batchSize
  ) public {
    uint256 amount = 1; // TODO: Only for testing
    address tokenAddress = EnergyToken.get();
    require(tokenAddress != address(0), "Invalid token address");
    require(amount > 0, "Amount must be greater than 0");

    IERC20 token = IERC20(tokenAddress);
    // SafeERC20 处理了转账失败的情况，会自动回滚交易
    token.safeTransferFrom(_msgSender(), address(this), amount);
    //uint8 skillType, uint256 playerId, uint8 sequenceNumber, uint32 itemId
    SkillProcessDelegationLib.startCreation(skillType, playerId, skillProcessSequenceNumber, itemId, batchSize);
  }

  function uniApiStartProduction(
    uint8 skillType,
    uint256 playerId,
    uint8 skillProcessSequenceNumber,
    uint32 itemId,
    uint32 batchSize
  ) public {
    uint256 amount = 1; // TODO: Only for testing
    address tokenAddress = EnergyToken.get();
    require(tokenAddress != address(0), "Invalid token address");
    require(amount > 0, "Amount must be greater than 0");

    IERC20 token = IERC20(tokenAddress);
    // SafeERC20 处理了转账失败的情况，会自动回滚交易
    token.safeTransferFrom(_msgSender(), address(this), amount);

    SkillProcessDelegationLib.startProduction(skillType, playerId, skillProcessSequenceNumber, itemId, batchSize);
  }

  function uniApiStartShipProduction(
    uint8 skillType,
    uint256 playerId,
    uint8 skillProcessSequenceNumber,
    uint32 itemId,
    ItemIdQuantityPair[] memory productionMaterials
  ) public {
    uint256 amount = 1; // TODO: Only for testing
    address tokenAddress = EnergyToken.get();
    require(tokenAddress != address(0), "Invalid token address");
    require(amount > 0, "Amount must be greater than 0");

    IERC20 token = IERC20(tokenAddress);
    // SafeERC20 处理了转账失败的情况，会自动回滚交易
    token.safeTransferFrom(_msgSender(), address(this), amount);

    SkillProcessDelegationLib.startShipProduction(skillType, playerId, skillProcessSequenceNumber, itemId, productionMaterials);
  }

  function uniApiRosterSetSail(
    uint256 rosterPlayerId,
    uint32 rosterSequenceNumber,
    uint256 playerId,
    uint32 targetCoordinatesX,
    uint32 targetCoordinatesY,
    uint64 energyAmount,
    uint64 sailDuration,
    uint32 updatedCoordinatesX,
    uint32 updatedCoordinatesY
  ) public {
    // TODO ...
  }
}
