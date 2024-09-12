// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Module } from "@latticexyz/world/src/Module.sol";
import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";
import { WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { revertWithBytes } from "@latticexyz/world/src/revertWithBytes.sol";
import { RESOURCE_SYSTEM, RESOURCE_NAMESPACE } from "@latticexyz/world/src/worldResourceTypes.sol";

// Import the AlwaysAllowDelegationControl contract
import { AlwaysAllowDelegationControl } from "./AlwaysAllowDelegationControl.sol";

contract AlwaysAllowDelegationModule is Module {
  using WorldResourceIdInstance for ResourceId;

  AlwaysAllowDelegationControl private immutable alwaysAllowDelegationControl = new AlwaysAllowDelegationControl();
  bytes14 constant NAMESPACE = bytes14("app");

  ResourceId constant NAMESPACE_ID = ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_NAMESPACE, NAMESPACE)));

  ResourceId constant DELEGATION =
    ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_SYSTEM, NAMESPACE, bytes16("Delegation"))));

  function install(bytes memory) public override {
    revert Module_NonRootInstallNotSupported();
    // IBaseWorld world = IBaseWorld(_world());

    // world.registerSystem(DELEGATION, alwaysAllowDelegationControl, true);

    // //systemId.getNamespaceId()
    // world.registerNamespaceDelegation(DELEGATION.getNamespaceId(), DELEGATION, new bytes(0));
  }

  function installRoot(bytes memory) public {
    //revert Module_RootInstallNotSupported();
    IBaseWorld world = IBaseWorld(_world());

    (bool success, bytes memory returnData) = address(world).delegatecall(
      abi.encodeCall(world.registerSystem, (DELEGATION, alwaysAllowDelegationControl, true))
    );
    if (!success) revertWithBytes(returnData);

    (success, returnData) = address(world).delegatecall(
      abi.encodeCall(world.registerNamespaceDelegation, (DELEGATION.getNamespaceId(), DELEGATION, new bytes(0)))
    );
    if (!success) revertWithBytes(returnData);
  }
}
