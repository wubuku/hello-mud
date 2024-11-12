// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { ShipItemMountingPosition } from "../codegen/index.sol";
import { ShipItemMountingPositionCreated, ShipItemMountingPositionUpdated } from "./ShipItemMountingPositionEvents.sol";
import { ShipItemMountingPositionCreateLogic } from "./ShipItemMountingPositionCreateLogic.sol";
import { ShipItemMountingPositionUpdateLogic } from "./ShipItemMountingPositionUpdateLogic.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";
import { NamespaceOwner } from "@latticexyz/world/src/codegen/tables/NamespaceOwner.sol";
import { ResourceId, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { IAppSystemErrors } from "./IAppSystemErrors.sol";

contract ShipItemMountingPositionSystem is System, IAppSystemErrors {
  using WorldResourceIdInstance for ResourceId;

  event ShipItemMountingPositionCreatedEvent(uint32 indexed itemId, uint8 indexed mountingPosition, uint8 equipmentCapacity);

  event ShipItemMountingPositionUpdatedEvent(uint32 indexed itemId, uint8 indexed mountingPosition, uint8 equipmentCapacity);

  function _requireNamespaceOwner() internal view {
    ResourceId _thisSystemId = SystemRegistry.get(address(this));
    address _thisNamespaceOwner = NamespaceOwner.get(_thisSystemId.getNamespaceId());
    if (_thisNamespaceOwner != _msgSender()) {
      revert RequireNamespaceOwner(_msgSender(), _thisNamespaceOwner);
    }
  }

  function shipItemMountingPositionCreate(uint32 itemId, uint8 mountingPosition, uint8 equipmentCapacity) public {
    _requireNamespaceOwner();
    uint8 __equipmentCapacity = ShipItemMountingPosition.get(itemId, mountingPosition);
    if (!(__equipmentCapacity == uint8(0))) {
      revert ShipItemMountingPositionAlreadyExists(itemId, mountingPosition);
    }
    ShipItemMountingPositionCreated memory shipItemMountingPositionCreated = ShipItemMountingPositionCreateLogic.verify(itemId, mountingPosition, equipmentCapacity);
    shipItemMountingPositionCreated.itemId = itemId;
    shipItemMountingPositionCreated.mountingPosition = mountingPosition;
    emit ShipItemMountingPositionCreatedEvent(shipItemMountingPositionCreated.itemId, shipItemMountingPositionCreated.mountingPosition, shipItemMountingPositionCreated.equipmentCapacity);
    uint8 new__EquipmentCapacity = ShipItemMountingPositionCreateLogic.mutate(shipItemMountingPositionCreated);
    ShipItemMountingPosition.set(itemId, mountingPosition, new__EquipmentCapacity);
  }

  function shipItemMountingPositionUpdate(uint32 itemId, uint8 mountingPosition, uint8 equipmentCapacity) public {
    _requireNamespaceOwner();
    uint8 __equipmentCapacity = ShipItemMountingPosition.get(itemId, mountingPosition);
    if (__equipmentCapacity == uint8(0)) {
      revert ShipItemMountingPositionDoesNotExist(itemId, mountingPosition);
    }
    ShipItemMountingPositionUpdated memory shipItemMountingPositionUpdated = ShipItemMountingPositionUpdateLogic.verify(itemId, mountingPosition, equipmentCapacity, __equipmentCapacity);
    shipItemMountingPositionUpdated.itemId = itemId;
    shipItemMountingPositionUpdated.mountingPosition = mountingPosition;
    emit ShipItemMountingPositionUpdatedEvent(shipItemMountingPositionUpdated.itemId, shipItemMountingPositionUpdated.mountingPosition, shipItemMountingPositionUpdated.equipmentCapacity);
    uint8 updated__EquipmentCapacity = ShipItemMountingPositionUpdateLogic.mutate(shipItemMountingPositionUpdated, __equipmentCapacity);
    ShipItemMountingPosition.set(itemId, mountingPosition, updated__EquipmentCapacity);
  }

}
