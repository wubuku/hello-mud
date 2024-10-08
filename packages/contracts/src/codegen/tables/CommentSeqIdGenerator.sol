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

library CommentSeqIdGenerator {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "app", name: "CommentSeqIdGene", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x74626170700000000000000000000000436f6d6d656e74536571496447656e65);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0008010008000000000000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (uint64)
  Schema constant _keySchema = Schema.wrap(0x0008010007000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (uint64)
  Schema constant _valueSchema = Schema.wrap(0x0008010007000000000000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "articleId";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](1);
    fieldNames[0] = "commentSeqId";
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
   * @notice Get commentSeqId.
   */
  function getCommentSeqId(uint64 articleId) internal view returns (uint64 commentSeqId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint64(bytes8(_blob)));
  }

  /**
   * @notice Get commentSeqId.
   */
  function _getCommentSeqId(uint64 articleId) internal view returns (uint64 commentSeqId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint64(bytes8(_blob)));
  }

  /**
   * @notice Get commentSeqId.
   */
  function get(uint64 articleId) internal view returns (uint64 commentSeqId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint64(bytes8(_blob)));
  }

  /**
   * @notice Get commentSeqId.
   */
  function _get(uint64 articleId) internal view returns (uint64 commentSeqId) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (uint64(bytes8(_blob)));
  }

  /**
   * @notice Set commentSeqId.
   */
  function setCommentSeqId(uint64 articleId, uint64 commentSeqId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((commentSeqId)), _fieldLayout);
  }

  /**
   * @notice Set commentSeqId.
   */
  function _setCommentSeqId(uint64 articleId, uint64 commentSeqId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((commentSeqId)), _fieldLayout);
  }

  /**
   * @notice Set commentSeqId.
   */
  function set(uint64 articleId, uint64 commentSeqId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((commentSeqId)), _fieldLayout);
  }

  /**
   * @notice Set commentSeqId.
   */
  function _set(uint64 articleId, uint64 commentSeqId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((commentSeqId)), _fieldLayout);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(uint64 articleId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(uint64 articleId) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(uint64 commentSeqId) internal pure returns (bytes memory) {
    return abi.encodePacked(commentSeqId);
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(uint64 commentSeqId) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(commentSeqId);

    EncodedLengths _encodedLengths;
    bytes memory _dynamicData;

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(uint64 articleId) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(uint256(articleId));

    return _keyTuple;
  }
}
