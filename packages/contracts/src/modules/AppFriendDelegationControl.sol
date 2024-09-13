// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { DelegationControl } from "@latticexyz/world/src/DelegationControl.sol";
import { ResourceId } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";
import { SystemRegistry } from "@latticexyz/world/src/codegen/tables/SystemRegistry.sol";

contract AppFriendDelegationControl is DelegationControl {
  ResourceId constant SHIP_BATTLE_SERVICE_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("ShipBattleServiceSystem"))))
      // NOTE: Only 16 bytes are used: "ShipBattleServic"
    );

  // SkillProcessServiceSystem
  ResourceId constant SKILL_PROCESS_SERVICE_SYSTEM =
    ResourceId.wrap(
      bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16(bytes("SkillProcessServiceSystem"))))
      // NOTE: Only 16 bytes are used: "SkillProcessServ"
    );

  //ShipBattleSystem
  ResourceId constant SHIP_BATTLE_SYSTEM =
    ResourceId.wrap(bytes32(abi.encodePacked(RESOURCE_SYSTEM, bytes14("app"), bytes16("ShipBattleSystem"))));

  function verify(address /*delegator*/, ResourceId systemId, bytes memory /*callData*/) public view returns (bool) {
    ResourceId callerSystemId = SystemRegistry.get(_msgSender());
    return
      ResourceId.unwrap(systemId) == ResourceId.unwrap(SHIP_BATTLE_SYSTEM) &&
      (
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SHIP_BATTLE_SERVICE_SYSTEM) ||
        ResourceId.unwrap(callerSystemId) == ResourceId.unwrap(SKILL_PROCESS_SERVICE_SYSTEM)
      ); // ||
  }

  // Optional: Override supportsInterface if needed
  //   function supportsInterface(bytes4 interfaceId) public pure override returns (bool) {
  //     return super.supportsInterface(interfaceId);
  //   }
}