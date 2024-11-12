// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { ItemToShipAttributes, ItemToShipAttributesData } from "../codegen/index.sol";
import { ItemToShipAttributesCreated, ItemToShipAttributesUpdated } from "./ItemToShipAttributesEvents.sol";
import { ItemToShipAttributesCreateLogic } from "./ItemToShipAttributesCreateLogic.sol";
import { ItemToShipAttributesUpdateLogic } from "./ItemToShipAttributesUpdateLogic.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { NamespaceOwner } from "@latticexyz/world/src/codegen/tables/NamespaceOwner.sol";
import { ResourceId, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { IAppSystemErrors } from "./IAppSystemErrors.sol";

contract ItemToShipAttributesSystem is System, IAppSystemErrors {
  using WorldResourceIdInstance for ResourceId;

  event ItemToShipAttributesCreatedEvent(uint32 indexed itemId, uint32 denominator, uint32 attackNumerator, uint32 protectionNumerator, uint32 speedNumerator, uint32 healthNumerator);

  event ItemToShipAttributesUpdatedEvent(uint32 indexed itemId, uint32 denominator, uint32 attackNumerator, uint32 protectionNumerator, uint32 speedNumerator, uint32 healthNumerator);

  function _requireNamespaceOwner() internal view {
    ResourceId _thisSystemId = SystemRegistry.get(address(this));
    address _thisNamespaceOwner = NamespaceOwner.get(_thisSystemId.getNamespaceId());
    if (_thisNamespaceOwner != _msgSender()) {
      revert RequireNamespaceOwner(_msgSender(), _thisNamespaceOwner);
    }
  }

  function itemToShipAttributesCreate(uint32 itemId, uint32 denominator, uint32 attackNumerator, uint32 protectionNumerator, uint32 speedNumerator, uint32 healthNumerator) public {
    _requireNamespaceOwner();
    ItemToShipAttributesData memory itemToShipAttributesData = ItemToShipAttributes.get(itemId);
    if (!(itemToShipAttributesData.denominator == uint32(0) && itemToShipAttributesData.attackNumerator == uint32(0) && itemToShipAttributesData.protectionNumerator == uint32(0) && itemToShipAttributesData.speedNumerator == uint32(0) && itemToShipAttributesData.healthNumerator == uint32(0))) {
      revert ItemToShipAttributesAlreadyExists(itemId);
    }
    ItemToShipAttributesCreated memory itemToShipAttributesCreated = ItemToShipAttributesCreateLogic.verify(itemId, denominator, attackNumerator, protectionNumerator, speedNumerator, healthNumerator);
    itemToShipAttributesCreated.itemId = itemId;
    emit ItemToShipAttributesCreatedEvent(itemToShipAttributesCreated.itemId, itemToShipAttributesCreated.denominator, itemToShipAttributesCreated.attackNumerator, itemToShipAttributesCreated.protectionNumerator, itemToShipAttributesCreated.speedNumerator, itemToShipAttributesCreated.healthNumerator);
    ItemToShipAttributesData memory newItemToShipAttributesData = ItemToShipAttributesCreateLogic.mutate(itemToShipAttributesCreated);
    ItemToShipAttributes.set(itemId, newItemToShipAttributesData);
  }

  function itemToShipAttributesUpdate(uint32 itemId, uint32 denominator, uint32 attackNumerator, uint32 protectionNumerator, uint32 speedNumerator, uint32 healthNumerator) public {
    _requireNamespaceOwner();
    ItemToShipAttributesData memory itemToShipAttributesData = ItemToShipAttributes.get(itemId);
    if (itemToShipAttributesData.denominator == uint32(0) && itemToShipAttributesData.attackNumerator == uint32(0) && itemToShipAttributesData.protectionNumerator == uint32(0) && itemToShipAttributesData.speedNumerator == uint32(0) && itemToShipAttributesData.healthNumerator == uint32(0)) {
      revert ItemToShipAttributesDoesNotExist(itemId);
    }
    ItemToShipAttributesUpdated memory itemToShipAttributesUpdated = ItemToShipAttributesUpdateLogic.verify(itemId, denominator, attackNumerator, protectionNumerator, speedNumerator, healthNumerator, itemToShipAttributesData);
    itemToShipAttributesUpdated.itemId = itemId;
    emit ItemToShipAttributesUpdatedEvent(itemToShipAttributesUpdated.itemId, itemToShipAttributesUpdated.denominator, itemToShipAttributesUpdated.attackNumerator, itemToShipAttributesUpdated.protectionNumerator, itemToShipAttributesUpdated.speedNumerator, itemToShipAttributesUpdated.healthNumerator);
    ItemToShipAttributesData memory updatedItemToShipAttributesData = ItemToShipAttributesUpdateLogic.mutate(itemToShipAttributesUpdated, itemToShipAttributesData);
    ItemToShipAttributes.set(itemId, updatedItemToShipAttributesData);
  }

}
