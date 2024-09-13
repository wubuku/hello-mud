// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { System } from "@latticexyz/world/src/System.sol";
import { Item, ItemData } from "../codegen/index.sol";
import { ItemCreated, ItemUpdated } from "./ItemEvents.sol";
import { ItemCreateLogic } from "./ItemCreateLogic.sol";
import { ItemUpdateLogic } from "./ItemUpdateLogic.sol";

contract ItemSystem is System {
  event ItemCreatedEvent(uint32 indexed itemId, bool requiredForCompletion, uint32 sellsFor, string name);

  event ItemUpdatedEvent(uint32 indexed itemId, bool requiredForCompletion, uint32 sellsFor, string name);

  function itemCreate(uint32 itemId, bool requiredForCompletion, uint32 sellsFor, string memory name) public {
    ItemData memory itemData = Item.get(itemId);
    require(
      itemData.requiredForCompletion == false && itemData.sellsFor == uint32(0) && bytes(itemData.name).length == 0,
      "Item already exists"
    );
    ItemCreated memory itemCreated = ItemCreateLogic.verify(itemId, requiredForCompletion, sellsFor, name);
    itemCreated.itemId = itemId;
    emit ItemCreatedEvent(itemCreated.itemId, itemCreated.requiredForCompletion, itemCreated.sellsFor, itemCreated.name);
    ItemData memory newItemData = ItemCreateLogic.mutate(itemCreated);
    Item.set(itemId, newItemData);
  }

  function itemUpdate(uint32 itemId, bool requiredForCompletion, uint32 sellsFor, string memory name) public {
    ItemData memory itemData = Item.get(itemId);
    require(
      !(itemData.requiredForCompletion == false && itemData.sellsFor == uint32(0) && bytes(itemData.name).length == 0),
      "Item does not exist"
    );
    ItemUpdated memory itemUpdated = ItemUpdateLogic.verify(itemId, requiredForCompletion, sellsFor, name, itemData);
    itemUpdated.itemId = itemId;
    emit ItemUpdatedEvent(itemUpdated.itemId, itemUpdated.requiredForCompletion, itemUpdated.sellsFor, itemUpdated.name);
    ItemData memory updatedItemData = ItemUpdateLogic.mutate(itemUpdated, itemData);
    Item.set(itemId, updatedItemData);
  }

}
