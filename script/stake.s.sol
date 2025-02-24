// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {StakingPool} from "../src/stake.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployStakingPool is Script {
    address public tokenAddress = 0x45d3B4E6D50BFFb87CF5b1129aFc2955927EBf49;

    function run() external {
        vm.startBroadcast();
        StakingPool stakingPool = new StakingPool(tokenAddress);
        console.log("StakingPool deployed at:", address(stakingPool));

        IERC20 token = IERC20(tokenAddress);
        uint256 deployerBalance = token.balanceOf(msg.sender);
        console.log("Deployer token balance:", deployerBalance);

        if (deployerBalance > 0) {
            token.transfer(address(stakingPool), deployerBalance / 2);
            console.log("Transferred some tokens to the StakingPool.");
        } else {
            console.log("Warning: No tokens in deployer's balance.");
        }

        vm.stopBroadcast();
    }
}
