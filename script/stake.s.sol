// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {StakingPool} from "../src/StakingPool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployStakingPool is Script {
    function run() external {
        vm.startBroadcast();

        address tokenAddress = 0xYourTokenAddressHere;
        StakingPool stakingPool = new StakingPool(IERC20(tokenAddress));

        console.log("StakingPool deployed at:", address(stakingPool));

        vm.stopBroadcast();
    }
}
