// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema } from "@latticexyz/store/src/Schema.sol";
import { EncodedLengths, EncodedLengthsLib } from "@latticexyz/store/src/EncodedLengths.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

library ArticleTag {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "app", name: "ArticleTag", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x7462617070000000000000000000000041727469636c65546167000000000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0000000100000000000000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (uint64, uint64)
  Schema constant _keySchema = Schema.wrap(0x0010020007070000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (string)
  Schema constant _valueSchema = Schema.wrap(0x00000001c5000000000000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](2);
    keyNames[0] = "articleId";
    keyNames[1] = "tagIndex";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](1);
    fieldNames[0] = "tag";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get tag.
   */
  function getTag(uint64 articleId, uint64 tagIndex) internal view returns (string memory tag) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Get tag.
   */
  function _getTag(uint64 articleId, uint64 tagIndex) internal view returns (string memory tag) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Get tag.
   */
  function get(uint64 articleId, uint64 tagIndex) internal view returns (string memory tag) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Get tag.
   */
  function _get(uint64 articleId, uint64 tagIndex) internal view returns (string memory tag) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (string(_blob));
  }

  /**
   * @notice Set tag.
   */
  function setTag(uint64 articleId, uint64 tagIndex, string memory tag) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, bytes((tag)));
  }

  /**
   * @notice Set tag.
   */
  function _setTag(uint64 articleId, uint64 tagIndex, string memory tag) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, bytes((tag)));
  }

  /**
   * @notice Set tag.
   */
  function set(uint64 articleId, uint64 tagIndex, string memory tag) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, bytes((tag)));
  }

  /**
   * @notice Set tag.
   */
  function _set(uint64 articleId, uint64 tagIndex, string memory tag) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, bytes((tag)));
  }

  /**
   * @notice Get the length of tag.
   */
  function lengthTag(uint64 articleId, uint64 tagIndex) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of tag.
   */
  function _lengthTag(uint64 articleId, uint64 tagIndex) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of tag.
   */
  function length(uint64 articleId, uint64 tagIndex) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get the length of tag.
   */
  function _length(uint64 articleId, uint64 tagIndex) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 1;
    }
  }

  /**
   * @notice Get an item of tag.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemTag(uint64 articleId, uint64 tagIndex, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Get an item of tag.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemTag(uint64 articleId, uint64 tagIndex, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Get an item of tag.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItem(uint64 articleId, uint64 tagIndex, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Get an item of tag.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItem(uint64 articleId, uint64 tagIndex, uint256 _index) internal view returns (string memory) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (string(_blob));
    }
  }

  /**
   * @notice Push a slice to tag.
   */
  function pushTag(uint64 articleId, uint64 tagIndex, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Push a slice to tag.
   */
  function _pushTag(uint64 articleId, uint64 tagIndex, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Push a slice to tag.
   */
  function push(uint64 articleId, uint64 tagIndex, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Push a slice to tag.
   */
  function _push(uint64 articleId, uint64 tagIndex, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, bytes((_slice)));
  }

  /**
   * @notice Pop a slice from tag.
   */
  function popTag(uint64 articleId, uint64 tagIndex) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Pop a slice from tag.
   */
  function _popTag(uint64 articleId, uint64 tagIndex) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Pop a slice from tag.
   */
  function pop(uint64 articleId, uint64 tagIndex) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Pop a slice from tag.
   */
  function _pop(uint64 articleId, uint64 tagIndex) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 1);
  }

  /**
   * @notice Update a slice of tag at `_index`.
   */
  function updateTag(uint64 articleId, uint64 tagIndex, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update a slice of tag at `_index`.
   */
  function _updateTag(uint64 articleId, uint64 tagIndex, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update a slice of tag at `_index`.
   */
  function update(uint64 articleId, uint64 tagIndex, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update a slice of tag at `_index`.
   */
  function _update(uint64 articleId, uint64 tagIndex, uint256 _index, string memory _slice) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    unchecked {
      bytes memory _encoded = bytes((_slice));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(uint64 articleId, uint64 tagIndex) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(uint64 articleId, uint64 tagIndex) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack dynamic data lengths using this table's schema.
   * @return _encodedLengths The lengths of the dynamic fields (packed into a single bytes32 value).
   */
  function encodeLengths(string memory tag) internal pure returns (EncodedLengths _encodedLengths) {
    // Lengths are effectively checked during copy by 2**40 bytes exceeding gas limits
    unchecked {
      _encodedLengths = EncodedLengthsLib.pack(bytes(tag).length);
    }
  }

  /**
   * @notice Tightly pack dynamic (variable length) data using this table's schema.
   * @return The dynamic data, encoded into a sequence of bytes.
   */
  function encodeDynamic(string memory tag) internal pure returns (bytes memory) {
    return abi.encodePacked(bytes((tag)));
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(string memory tag) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData;
    EncodedLengths _encodedLengths = encodeLengths(tag);
    bytes memory _dynamicData = encodeDynamic(tag);

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(uint64 articleId, uint64 tagIndex) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(articleId));
    _keyTuple[1] = bytes32(uint256(tagIndex));

    return _keyTuple;
  }
}