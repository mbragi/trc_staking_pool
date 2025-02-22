// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {StakingPool} from "../src/stake.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployStakingPool is Script {
    function run() external {
        vm.startBroadcast();

        address tokenAddress = 0x8D4f92Eb66710291872Fa11D8bCb290c233699F0;
        StakingPool stakingPool = new StakingPool(tokenAddress);

        console.log("StakingPool deployed at:", address(stakingPool));

        vm.stopBroadcast();
    }
}
