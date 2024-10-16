// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { EnergyToken } from "../codegen/index.sol";
import { EnergyTokenCreated, EnergyTokenUpdated } from "./EnergyTokenEvents.sol";
import { EnergyTokenCreateLogic } from "./EnergyTokenCreateLogic.sol";
import { EnergyTokenUpdateLogic } from "./EnergyTokenUpdateLogic.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { NamespaceOwner } from "@latticexyz/world/src/codegen/tables/NamespaceOwner.sol";
import { ResourceId, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { IAppSystemErrors } from "./IAppSystemErrors.sol";

contract EnergyTokenSystem is System, IAppSystemErrors {
  using WorldResourceIdInstance for ResourceId;

  event EnergyTokenCreatedEvent(address tokenAddress);

  event EnergyTokenUpdatedEvent(address tokenAddress);

  function _requireNamespaceOwner() internal view {
    ResourceId _thisSystemId = SystemRegistry.get(address(this));
    address _thisNamespaceOwner = NamespaceOwner.get(_thisSystemId.getNamespaceId());
    if (_thisNamespaceOwner != _msgSender()) {
      revert RequireNamespaceOwner(_msgSender(), _thisNamespaceOwner);
    }
  }

  function energyTokenCreate(address tokenAddress) public {
    _requireNamespaceOwner();
    address __tokenAddress = EnergyToken.get();
    if (!(__tokenAddress == address(0))) {
      revert EnergyTokenAlreadyExists();
    }
    EnergyTokenCreated memory energyTokenCreated = EnergyTokenCreateLogic.verify(tokenAddress);
    emit EnergyTokenCreatedEvent(energyTokenCreated.tokenAddress);
    address new__TokenAddress = EnergyTokenCreateLogic.mutate(energyTokenCreated);
    EnergyToken.set(new__TokenAddress);
  }

  function energyTokenUpdate(address tokenAddress) public {
    _requireNamespaceOwner();
    address __tokenAddress = EnergyToken.get();
    if (__tokenAddress == address(0)) {
      revert EnergyTokenDoesNotExist();
    }
    EnergyTokenUpdated memory energyTokenUpdated = EnergyTokenUpdateLogic.verify(tokenAddress, __tokenAddress);
    emit EnergyTokenUpdatedEvent(energyTokenUpdated.tokenAddress);
    address updated__TokenAddress = EnergyTokenUpdateLogic.mutate(energyTokenUpdated, __tokenAddress);
    EnergyToken.set(updated__TokenAddress);
  }

}
