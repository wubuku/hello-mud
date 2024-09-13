// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Module } from "@latticexyz/world/src/Module.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";
import { WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { revertWithBytes } from "@latticexyz/world/src/revertWithBytes.sol";
import { RESOURCE_SYSTEM, RESOURCE_NAMESPACE } from "@latticexyz/world/src/worldResourceTypes.sol";

// Import the AppFriendDelegationControl contract
import { AppFriendDelegationControl } from "./AppFriendDelegationControl.sol";

contract AppNamespaceDelegationModule is Module {
  using WorldResourceIdInstance for ResourceId;

  AppFriendDelegationControl private immutable appFriendDelegationControl = new AppFriendDelegationControl();
  bytes14 constant APP_NAMESPACE = bytes14("app");
  // For example:
  bytes14 constant EXAMPLE_LONG_FOO_BAR_NAMESPACE = bytes14(bytes("ExampleLongFooBarNamespace"));
  // NOTE: Only 14 bytes are used: "ExampleLongFoo"
  ResourceId constant APP_NAMESPACE_ID = ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_NAMESPACE, APP_NAMESPACE)));
  ResourceId constant APP_NAMESPACE_DELEGATION =
    ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_SYSTEM, APP_NAMESPACE, bytes16("Delegation"))));

  function install(bytes memory) public pure override {
    revert Module_NonRootInstallNotSupported();
    // IBaseWorld world = IBaseWorld(_world());

    // world.registerSystem(DELEGATION, appFriendDelegationControl, true);

    // //systemId.getNamespaceId()
    // world.registerNamespaceDelegation(DELEGATION.getNamespaceId(), DELEGATION, new bytes(0));
  }

  function installRoot(bytes memory) public {
    //revert Module_RootInstallNotSupported();
    IBaseWorld world = IBaseWorld(_world());
    bool success;
    bytes memory returnData;

    (success, returnData) = address(world).delegatecall(
      abi.encodeCall(world.registerSystem, (APP_NAMESPACE_DELEGATION, appFriendDelegationControl, true))
    );
    if (!success) revertWithBytes(returnData);

    (success, returnData) = address(world).delegatecall(
      abi.encodeCall(world.registerNamespaceDelegation, (APP_NAMESPACE_ID, APP_NAMESPACE_DELEGATION, new bytes(0)))
    );
    if (!success) revertWithBytes(returnData);
  }
}
