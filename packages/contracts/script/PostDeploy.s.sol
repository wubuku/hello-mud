// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { Systems } from "@latticexyz/world/src/codegen/tables/Systems.sol";
import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { IWorld } from "../src/codegen/world/IWorld.sol";
import { Energy } from "../src/tokens/Energy.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PostDeploy is Script {
  function run(address worldAddress) external {
    // Specify a store so that you can use tables directly in PostDeploy
    StoreSwitch.setStoreAddress(worldAddress);

    // Load the private key from the `PRIVATE_KEY` environment variable (in .env)
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    address deployerAddress = vm.addr(deployerPrivateKey);

    // Start broadcasting transactions from the deployer account
    vm.startBroadcast(deployerPrivateKey);

    console.log("Deploying contracts with the account:", deployerAddress);

    uint256 balance = deployerAddress.balance;
    console.log("Account balance:", balance);

    Energy energyToken = new Energy(deployerAddress);

    console.log("ENERGY Token address:", address(energyToken));

    ResourceId skillProcessServiceSystemId = WorldResourceIdLib.encode({
      typeId: RESOURCE_SYSTEM,
      namespace: "app",
      name: "SkillProcessServ" // NOTE: Only the first 16 characters are used. Original: "SkillProcessServiceSystem"
    });
    (address systemAddress, bool publicAccess) = Systems.get(skillProcessServiceSystemId);
    console.log("SkillProcessServiceSystem address:", systemAddress);
    console.log("SkillProcessServiceSystem publicAccess:", publicAccess);

    IERC20 energyIErc20 = IERC20(address(energyToken));
    energyIErc20.approve(systemAddress, 10000 * 10 ** 18);
    console.log("Approved SkillProcessServiceSystem to spend ENERGY tokens");

    IWorld(worldAddress).app__energyTokenCreate(address(energyToken));

    // Call increment on the world via the registered function selector
    uint32 newValue = IWorld(worldAddress).app__increment();
    console.log("Increment via IWorld:", newValue);

    vm.stopBroadcast();
  }
}
