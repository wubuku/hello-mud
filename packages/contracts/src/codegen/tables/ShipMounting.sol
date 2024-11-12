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

struct ShipMountingData {
  bool existing;
  uint32[] equipmentIds;
  uint32[] equipmentQuantities;
}

library ShipMounting {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "app", name: "ShipMounting", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x74626170700000000000000000000000536869704d6f756e74696e6700000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0001010201000000000000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (uint256, uint8)
  Schema constant _keySchema = Schema.wrap(0x002102001f000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (bool, uint32[], uint32[])
  Schema constant _valueSchema = Schema.wrap(0x0001010260656500000000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](2);
    keyNames[0] = "shipIdMountingPositionPairShipId";
    keyNames[1] = "shipIdMountingPositionPairMountingPosition";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](3);
    fieldNames[0] = "existing";
    fieldNames[1] = "equipmentIds";
    fieldNames[2] = "equipmentQuantities";
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
   * @notice Get existing.
   */
  function getExisting(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (bool existing) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Get existing.
   */
  function _getExisting(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (bool existing) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (_toBool(uint8(bytes1(_blob))));
  }

  /**
   * @notice Set existing.
   */
  function setExisting(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    bool existing
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((existing)), _fieldLayout);
  }

  /**
   * @notice Set existing.
   */
  function _setExisting(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    bool existing
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((existing)), _fieldLayout);
  }

  /**
   * @notice Get equipmentIds.
   */
  function getEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (uint32[] memory equipmentIds) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint32());
  }

  /**
   * @notice Get equipmentIds.
   */
  function _getEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (uint32[] memory equipmentIds) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint32());
  }

  /**
   * @notice Set equipmentIds.
   */
  function setEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint32[] memory equipmentIds
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode((equipmentIds)));
  }

  /**
   * @notice Set equipmentIds.
   */
  function _setEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint32[] memory equipmentIds
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode((equipmentIds)));
  }

  /**
   * @notice Get the length of equipmentIds.
   */
  function lengthEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 4;
    }
  }

  /**
   * @notice Get the length of equipmentIds.
   */
  function _lengthEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 4;
    }
  }

  /**
   * @notice Get an item of equipmentIds.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint256 _index
  ) internal view returns (uint32) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 4, (_index + 1) * 4);
      return (uint32(bytes4(_blob)));
    }
  }

  /**
   * @notice Get an item of equipmentIds.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint256 _index
  ) internal view returns (uint32) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 4, (_index + 1) * 4);
      return (uint32(bytes4(_blob)));
    }
  }

  /**
   * @notice Push an element to equipmentIds.
   */
  function pushEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint32 _element
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to equipmentIds.
   */
  function _pushEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint32 _element
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from equipmentIds.
   */
  function popEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 4);
  }

  /**
   * @notice Pop an element from equipmentIds.
   */
  function _popEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 4);
  }

  /**
   * @notice Update an element of equipmentIds at `_index`.
   */
  function updateEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint256 _index,
    uint32 _element
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 4), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of equipmentIds at `_index`.
   */
  function _updateEquipmentIds(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint256 _index,
    uint32 _element
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 4), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get equipmentQuantities.
   */
  function getEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (uint32[] memory equipmentQuantities) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 1);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint32());
  }

  /**
   * @notice Get equipmentQuantities.
   */
  function _getEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (uint32[] memory equipmentQuantities) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 1);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint32());
  }

  /**
   * @notice Set equipmentQuantities.
   */
  function setEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint32[] memory equipmentQuantities
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 1, EncodeArray.encode((equipmentQuantities)));
  }

  /**
   * @notice Set equipmentQuantities.
   */
  function _setEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint32[] memory equipmentQuantities
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreCore.setDynamicField(_tableId, _keyTuple, 1, EncodeArray.encode((equipmentQuantities)));
  }

  /**
   * @notice Get the length of equipmentQuantities.
   */
  function lengthEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 4;
    }
  }

  /**
   * @notice Get the length of equipmentQuantities.
   */
  function _lengthEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 4;
    }
  }

  /**
   * @notice Get an item of equipmentQuantities.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint256 _index
  ) internal view returns (uint32) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 4, (_index + 1) * 4);
      return (uint32(bytes4(_blob)));
    }
  }

  /**
   * @notice Get an item of equipmentQuantities.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint256 _index
  ) internal view returns (uint32) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 4, (_index + 1) * 4);
      return (uint32(bytes4(_blob)));
    }
  }

  /**
   * @notice Push an element to equipmentQuantities.
   */
  function pushEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint32 _element
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 1, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to equipmentQuantities.
   */
  function _pushEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint32 _element
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 1, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from equipmentQuantities.
   */
  function popEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 1, 4);
  }

  /**
   * @notice Pop an element from equipmentQuantities.
   */
  function _popEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 1, 4);
  }

  /**
   * @notice Update an element of equipmentQuantities at `_index`.
   */
  function updateEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint256 _index,
    uint32 _element
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 4), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of equipmentQuantities at `_index`.
   */
  function _updateEquipmentQuantities(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    uint256 _index,
    uint32 _element
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 4), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get the full data.
   */
  function get(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (ShipMountingData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal view returns (ShipMountingData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    bool existing,
    uint32[] memory equipmentIds,
    uint32[] memory equipmentQuantities
  ) internal {
    bytes memory _staticData = encodeStatic(existing);

    EncodedLengths _encodedLengths = encodeLengths(equipmentIds, equipmentQuantities);
    bytes memory _dynamicData = encodeDynamic(equipmentIds, equipmentQuantities);

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    bool existing,
    uint32[] memory equipmentIds,
    uint32[] memory equipmentQuantities
  ) internal {
    bytes memory _staticData = encodeStatic(existing);

    EncodedLengths _encodedLengths = encodeLengths(equipmentIds, equipmentQuantities);
    bytes memory _dynamicData = encodeDynamic(equipmentIds, equipmentQuantities);

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    ShipMountingData memory _table
  ) internal {
    bytes memory _staticData = encodeStatic(_table.existing);

    EncodedLengths _encodedLengths = encodeLengths(_table.equipmentIds, _table.equipmentQuantities);
    bytes memory _dynamicData = encodeDynamic(_table.equipmentIds, _table.equipmentQuantities);

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition,
    ShipMountingData memory _table
  ) internal {
    bytes memory _staticData = encodeStatic(_table.existing);

    EncodedLengths _encodedLengths = encodeLengths(_table.equipmentIds, _table.equipmentQuantities);
    bytes memory _dynamicData = encodeDynamic(_table.equipmentIds, _table.equipmentQuantities);

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(bytes memory _blob) internal pure returns (bool existing) {
    existing = (_toBool(uint8(Bytes.getBytes1(_blob, 0))));
  }

  /**
   * @notice Decode the tightly packed blob of dynamic data using the encoded lengths.
   */
  function decodeDynamic(
    EncodedLengths _encodedLengths,
    bytes memory _blob
  ) internal pure returns (uint32[] memory equipmentIds, uint32[] memory equipmentQuantities) {
    uint256 _start;
    uint256 _end;
    unchecked {
      _end = _encodedLengths.atIndex(0);
    }
    equipmentIds = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_uint32());

    _start = _end;
    unchecked {
      _end += _encodedLengths.atIndex(1);
    }
    equipmentQuantities = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_uint32());
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   * @param _encodedLengths Encoded lengths of dynamic fields.
   * @param _dynamicData Tightly packed dynamic fields.
   */
  function decode(
    bytes memory _staticData,
    EncodedLengths _encodedLengths,
    bytes memory _dynamicData
  ) internal pure returns (ShipMountingData memory _table) {
    (_table.existing) = decodeStatic(_staticData);

    (_table.equipmentIds, _table.equipmentQuantities) = decodeDynamic(_encodedLengths, _dynamicData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(bool existing) internal pure returns (bytes memory) {
    return abi.encodePacked(existing);
  }

  /**
   * @notice Tightly pack dynamic data lengths using this table's schema.
   * @return _encodedLengths The lengths of the dynamic fields (packed into a single bytes32 value).
   */
  function encodeLengths(
    uint32[] memory equipmentIds,
    uint32[] memory equipmentQuantities
  ) internal pure returns (EncodedLengths _encodedLengths) {
    // Lengths are effectively checked during copy by 2**40 bytes exceeding gas limits
    unchecked {
      _encodedLengths = EncodedLengthsLib.pack(equipmentIds.length * 4, equipmentQuantities.length * 4);
    }
  }

  /**
   * @notice Tightly pack dynamic (variable length) data using this table's schema.
   * @return The dynamic data, encoded into a sequence of bytes.
   */
  function encodeDynamic(
    uint32[] memory equipmentIds,
    uint32[] memory equipmentQuantities
  ) internal pure returns (bytes memory) {
    return abi.encodePacked(EncodeArray.encode((equipmentIds)), EncodeArray.encode((equipmentQuantities)));
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    bool existing,
    uint32[] memory equipmentIds,
    uint32[] memory equipmentQuantities
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(existing);

    EncodedLengths _encodedLengths = encodeLengths(equipmentIds, equipmentQuantities);
    bytes memory _dynamicData = encodeDynamic(equipmentIds, equipmentQuantities);

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(
    uint256 shipIdMountingPositionPairShipId,
    uint8 shipIdMountingPositionPairMountingPosition
  ) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32(uint256(shipIdMountingPositionPairShipId));
    _keyTuple[1] = bytes32(uint256(shipIdMountingPositionPairMountingPosition));

    return _keyTuple;
  }
}

/**
 * @notice Cast a value to a bool.
 * @dev Boolean values are encoded as uint8 (1 = true, 0 = false), but Solidity doesn't allow casting between uint8 and bool.
 * @param value The uint8 value to convert.
 * @return result The boolean value.
 */
function _toBool(uint8 value) pure returns (bool result) {
  assembly {
    result := value
  }
}
