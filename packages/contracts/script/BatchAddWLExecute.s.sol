// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
//import { Tasks, TasksData } from "../src/codegen/index.sol";

// We need to create the ResourceID for the System we are calling
import { ResourceId, WorldResourceIdLib, WorldResourceIdInstance } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { SystemCallData } from "@latticexyz/world/src/modules/init/types.sol";

// 添加到白名单 forge script BatchAddWL.s.sol:BatchCall --sig "run(address)" 0x63381030dda22c888f2548436c73146ef835ab9e --broadcast --rpc-url https://odyssey.storyrpc.io/
// 从白名单移除：cast send 0xe271ed2e37a0926a70f824ca7dc1bc74d1d586e7 "app__islandClaimWhitelistUpdate(address,bool)" "0x20C22dC5022Aeabbd30c8b594bfd44fB167abE70" false --rpc-url "http://127.0.0.1:8545" --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --json
// cast send {worldAddress} "app__islandClaimWhitelistUpdate(address,bool)" "walletAddress" false --rpc-url "http://127.0.0.1:8545" --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --json
contract BatchCall is Script {
  function run(address worldAddress) external {
    StoreSwitch.setStoreAddress(worldAddress);
    //IWorld world = IWorld(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    ResourceId systemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "IslandClaimWhite"
    });
    address[3] memory walletAddresses = [
      address(0x269E2038cb7b084830f3c12c5041A5c52677d525),
      address(0x79785B77EE18F14BcE7006d9583D26279A39bAF7),
      address(0xc173bB17b5D2C7BCEd8a6f50E6F9c1bD6bde48DD)
    ];

    SystemCallData[] memory calls = new SystemCallData[](walletAddresses.length);
    for (uint i = 0; i < walletAddresses.length; i++) {
      calls[i].systemId = systemId;
      calls[i].callData = abi.encodeWithSignature("islandClaimWhitelistAdd(address)", walletAddresses[i]);
    }
    bytes[] memory returnData = IWorld(worldAddress).batchCall(calls);
    for (uint i = 0; i < returnData.length; i++) {
      console.log("The return value is:");
      console.logBytes(returnData[i]);
    }
    //world.app__islandClaimWhitelistUpdate(accountAddress, allowed);
    vm.stopBroadcast();
  }
}
