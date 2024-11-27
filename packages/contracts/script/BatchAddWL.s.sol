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

// 添加到白名单 forge script BatchAddWL.s.sol:BatchAddWL --sig "run(address)" 0x63381030dda22c888f2548436c73146ef835ab9e --broadcast --rpc-url https://odyssey.storyrpc.io/
// 从白名单移除：cast send 0xe271ed2e37a0926a70f824ca7dc1bc74d1d586e7 "app__islandClaimWhitelistUpdate(address,bool)" "0x20C22dC5022Aeabbd30c8b594bfd44fB167abE70" false --rpc-url "http://127.0.0.1:8545" --private-key xxx --json
// cast send {worldAddress} "app__islandClaimWhitelistUpdate(address,bool)" "walletAddress" false --rpc-url "http://127.0.0.1:8545" --private-key xxx --json
contract BatchAddWL is Script {
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
    address[] memory walletAddresses = new address[](3);
    walletAddresses[0] = address(0xbb46E65BAB7719C3819b1f7524B3f3878D8eC2A9);
    walletAddresses[1] = address(0x0Ad20075961249c72Df687A191D66DaFda16E9AB);
    walletAddresses[2] = address(0x76ee2b69843154E482f2E7bF1560F88e61b2A9BF);

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
