// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { System } from "@latticexyz/world/src/System.sol";
import { ItemIdQuantityPair } from "./ItemIdQuantityPair.sol";
import { EnergyToken, ItemCreationData, ItemCreation, ItemProductionData, ItemProduction } from "../codegen/index.sol";
import { SafeERC20, IERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { SkillProcessDelegatecallLib } from "./SkillProcessDelegatecallLib.sol";
import { RosterDelegatecallLib } from "./RosterDelegatecallLib.sol";
import { RosterSailUtil } from "../utils/RosterSailUtil.sol";
import { Coordinates } from "../systems/Coordinates.sol";
import { UpdateLocationParams } from "./UpdateLocationParams.sol";

contract AggregatorServiceSystem is System {
  using SafeERC20 for IERC20;

  error InvalidTokenAddress(address tokenAddress);
  error InvalidEnergyAmount(uint256 energyCost);
  error InsufficientEnergy(uint256 requiredEnergy, uint256 providedEnergy);

  function uniApiStartCreation(
    uint8 skillType,
    uint256 playerId,
    uint8 skillProcessSequenceNumber,
    uint32 itemId,
    uint32 batchSize
  ) public {
    ItemCreationData memory itemCreationData = ItemCreation.get(skillType, itemId);
    uint256 energyCost = uint256(itemCreationData.energyCost) * batchSize;
    address tokenAddress = EnergyToken.get();
    if (tokenAddress == address(0)) {
      revert InvalidTokenAddress(tokenAddress);
    }
    if (energyCost <= 0) {
      revert InvalidEnergyAmount(energyCost);
    }

    IERC20 token = IERC20(tokenAddress);
    token.safeTransferFrom(_msgSender(), address(this), energyCost);

    SkillProcessDelegatecallLib.startCreation(skillType, playerId, skillProcessSequenceNumber, itemId, batchSize);
  }

  function uniApiStartProduction(
    uint8 skillType,
    uint256 playerId,
    uint8 skillProcessSequenceNumber,
    uint32 itemId,
    uint32 batchSize
  ) public {
    ItemProductionData memory itemProductionData = ItemProduction.get(skillType, itemId);
    uint256 energyCost = uint256(itemProductionData.energyCost) * batchSize;
    address tokenAddress = EnergyToken.get();
    if (tokenAddress == address(0)) {
      revert InvalidTokenAddress(tokenAddress);
    }
    if (energyCost <= 0) {
      revert InvalidEnergyAmount(energyCost);
    }

    IERC20 token = IERC20(tokenAddress);
    token.safeTransferFrom(_msgSender(), address(this), energyCost);

    SkillProcessDelegatecallLib.startProduction(skillType, playerId, skillProcessSequenceNumber, itemId, batchSize);
  }

  function uniApiStartShipProduction(
    uint8 skillType,
    uint256 playerId,
    uint8 skillProcessSequenceNumber,
    uint32 itemId,
    ItemIdQuantityPair[] memory productionMaterials
  ) public {
    ItemProductionData memory itemProductionData = ItemProduction.get(skillType, itemId);
    uint256 energyCost = itemProductionData.energyCost;
    address tokenAddress = EnergyToken.get();
    if (tokenAddress == address(0)) {
      revert InvalidTokenAddress(tokenAddress);
    }
    if (energyCost <= 0) {
      revert InvalidEnergyAmount(energyCost);
    }

    IERC20 token = IERC20(tokenAddress);
    token.safeTransferFrom(_msgSender(), address(this), energyCost);

    SkillProcessDelegatecallLib.startShipProduction(
      skillType,
      playerId,
      skillProcessSequenceNumber,
      itemId,
      productionMaterials
    );
  }

  function uniApiRosterSetSail(
    uint256 playerId,
    uint32 rosterSequenceNumber,
    uint32 targetCoordinatesX,
    uint32 targetCoordinatesY,
    uint64 energyAmount,
    uint64 sailDuration,
    UpdateLocationParams memory updateLocationParams,
    Coordinates[] memory intermediatePoints
  ) public {
    //uint32 newUpdatedCoordinatesX, uint32 newUpdatedCoordinatesY
    uint256 requiredEnergy = RosterSailUtil.calculateEnergyCost(
      playerId,
      rosterSequenceNumber,
      //targetCoordinatesX,
      //targetCoordinatesY,
      sailDuration
      //updatedCoordinatesX,
      //updatedCoordinatesY
    );
    if (requiredEnergy > energyAmount) {
      revert InsufficientEnergy(requiredEnergy, energyAmount);
    }
    address tokenAddress = EnergyToken.get();
    if (tokenAddress == address(0)) {
      revert InvalidTokenAddress(tokenAddress);
    }
    if (energyAmount <= 0) {
      revert InvalidEnergyAmount(energyAmount);
    }

    IERC20 token = IERC20(tokenAddress);
    token.safeTransferFrom(_msgSender(), address(this), energyAmount);

    //
    // TODO: If roster is already underway, update its location
    //
    RosterDelegatecallLib.setSail(
      playerId,
      rosterSequenceNumber,
      targetCoordinatesX,
      targetCoordinatesY,
      sailDuration,
      updateLocationParams,
      intermediatePoints
    );
  }

  function uniApiRosterUpdateLocation(
    uint256 playerId,
    uint32 rosterSequenceNumber,
    UpdateLocationParams memory updateLocationParams
  ) public {
    RosterDelegatecallLib.updateLocation(playerId, rosterSequenceNumber, updateLocationParams);
  }
}
