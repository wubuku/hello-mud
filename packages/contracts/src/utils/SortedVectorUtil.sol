// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../systems/ItemIdQuantityPair.sol";

library SortedVectorUtil {
  uint8 private constant EQUAL = 0;
  uint8 private constant LESS_THAN = 1;
  uint8 private constant GREATER_THAN = 2;

  error ItemAlreadyExists();
  error InsufficientQuantity();
  error ItemNotFound();
  error EmptyList();
  error IncorrectListLength();
  error CustomError(uint256 errorCode);

  function newItemIdQuantityPairs(
    uint32[] memory itemIdList,
    uint32[] memory itemQuantityList
  ) internal pure returns (ItemIdQuantityPair[] memory) {
    if (itemIdList.length == 0) revert EmptyList();
    if (itemIdList.length != itemQuantityList.length) revert IncorrectListLength();

    ItemIdQuantityPair[] memory items = new ItemIdQuantityPair[](0);
    for (uint i = 0; i < itemIdList.length; i++) {
      items = insertOrAddItemIdQuantityPair(items, ItemIdQuantityPair(itemIdList[i], itemQuantityList[i]));
    }
    return items;
  }

  function itemIdQuantityPairsMultiply(
    ItemIdQuantityPair[] memory itemIdQuantityPairs,
    uint32 multiplier
  ) internal pure returns (ItemIdQuantityPair[] memory) {
    ItemIdQuantityPair[] memory items = new ItemIdQuantityPair[](0);
    for (uint i = 0; i < itemIdQuantityPairs.length; i++) {
      ItemIdQuantityPair memory pair = itemIdQuantityPairs[i];
      items = insertOrAddItemIdQuantityPair(items, ItemIdQuantityPair(pair.itemId, pair.quantity * multiplier));
    }
    return items;
  }

  function mergeItemIdQuantityPairs(
    ItemIdQuantityPair[] memory merged,
    ItemIdQuantityPair[] memory other
  ) internal pure returns (ItemIdQuantityPair[] memory) {
    for (uint i = 0; i < other.length; i++) {
      merged = insertOrAddItemIdQuantityPair(merged, other[i]);
    }
    return merged;
  }

  function subtractItemIdQuantityPairs(
    ItemIdQuantityPair[] memory minuend,
    ItemIdQuantityPair[] memory subtrahend
  ) internal pure returns (ItemIdQuantityPair[] memory) {
    for (uint i = 0; i < subtrahend.length; i++) {
      minuend = subtractItemIdQuantityPair(minuend, subtrahend[i]);
    }
    return minuend;
  }

  function insertOrAddItemIdQuantityPair(
    ItemIdQuantityPair[] memory v,
    ItemIdQuantityPair memory pair
  ) internal pure returns (ItemIdQuantityPair[] memory) {
    (bool found, uint index) = binarySearchItemIdQuantityPair(v, pair.itemId);
    if (found) {
      v[index].quantity += pair.quantity;
    } else {
      ItemIdQuantityPair[] memory newV = new ItemIdQuantityPair[](v.length + 1);
      for (uint i = 0; i < index; i++) {
        newV[i] = v[i];
      }
      newV[index] = pair;
      for (uint i = index; i < v.length; i++) {
        newV[i + 1] = v[i];
      }
      return newV;
    }
    return v;
  }

  function subtractItemIdQuantityPair(
    ItemIdQuantityPair[] memory v,
    ItemIdQuantityPair memory pair
  ) internal pure returns (ItemIdQuantityPair[] memory) {
    (bool found, uint index) = binarySearchItemIdQuantityPair(v, pair.itemId);
    if (!found) {
      revert ItemNotFound();
    }
    if (v[index].quantity < pair.quantity) {
      revert InsufficientQuantity();
    }
    v[index].quantity -= pair.quantity;
    if (v[index].quantity == 0) {
      ItemIdQuantityPair[] memory newV = new ItemIdQuantityPair[](v.length - 1);
      for (uint i = 0; i < index; i++) {
        newV[i] = v[i];
      }
      for (uint i = index + 1; i < v.length; i++) {
        newV[i - 1] = v[i];
      }
      return newV;
    }
    return v;
  }

  function getItemIdQuantityPairOrRevert(
    ItemIdQuantityPair[] memory v,
    uint32 itemId,
    uint256 err
  ) internal pure returns (ItemIdQuantityPair memory) {
    (bool found, uint index) = binarySearchItemIdQuantityPair(v, itemId);
    if (!found) {
      revert CustomError(err);
    }
    return v[index];
  }

  function binarySearchItemIdQuantityPair(
    ItemIdQuantityPair[] memory v,
    uint32 itemId
  ) internal pure returns (bool, uint) {
    uint low = 0;
    uint high = v.length;
    while (low < high) {
      uint mid = low + (high - low) / 2;
      if (v[mid].itemId == itemId) {
        return (true, mid);
      } else if (v[mid].itemId < itemId) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return (false, low);
  }

  function addId(uint256[] storage v, uint256 id) internal {
    (bool found, uint index) = binarySearchId(v, id);
    if (found) {
      revert ItemAlreadyExists();
    }
    v.push(id);
    for (uint i = v.length - 1; i > index; i--) {
      v[i] = v[i - 1];
    }
    v[index] = id;
  }

  function removeId(uint256[] storage v, uint256 id) internal {
    (bool found, uint index) = binarySearchId(v, id);
    if (!found) {
      revert ItemNotFound();
    }
    for (uint i = index; i < v.length - 1; i++) {
      v[i] = v[i + 1];
    }
    v.pop();
  }

  function findId(uint256[] memory v, uint256 id) internal pure returns (bool, uint256) {
    (bool found, uint index) = binarySearchId(v, id);
    return (found, index);
  }

  function binarySearchId(uint256[] memory v, uint256 id) internal pure returns (bool, uint) {
    uint low = 0;
    uint high = v.length;
    while (low < high) {
      uint mid = low + (high - low) / 2;
      uint256 midValue = v[mid];
      if (midValue == id) {
        return (true, mid);
      } else if (midValue < id) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }
    return (false, low);
  }

  function concatIdsBytes(uint256[] memory ids) internal pure returns (bytes memory) {
    bytes memory result = new bytes(ids.length * 32);
    for (uint i = 0; i < ids.length; i++) {
      bytes32 idBytes = bytes32(ids[i]);
      assembly {
        mstore(add(result, add(32, mul(i, 32))), idBytes)
      }
    }
    return result;
  }
}
