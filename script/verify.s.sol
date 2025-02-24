// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";

contract VerifyStakingPool is Script {
    function run(address stakingPoolAddress) external {
        console.log("Verifying contract at:", stakingPoolAddress);

        string[] memory cmd = new string[](6);
        cmd[0] = "forge";
        cmd[1] = "verify-contract";
        cmd[2] = "--chain-id";
        cmd[3] = "1";
        cmd[4] = vm.toString(stakingPoolAddress);
        cmd[5] = "src/stake.sol:StakingPool";

        vm.ffi(cmd);
        console.log("Verification process initiated.");
    }
}
