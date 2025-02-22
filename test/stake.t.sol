// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {StakingPool} from "../src/stake.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Mock is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract StakingPoolTest is Test {
    StakingPool stakingPool;
    ERC20Mock stakingToken;
    address user = address(1);

    function setUp() public {
        stakingToken = new ERC20Mock("Trash Coin", "TRC");
        stakingToken.mint(address(this), 1000 * 10**18);
        stakingPool = new StakingPool(IERC20(address(stakingToken)));

        stakingToken.mint(user, 500 * 10**18);
        vm.startPrank(user);
        stakingToken.approve(address(stakingPool), 500 * 10**18);
        vm.stopPrank();
    }

    function testStake() public {
        vm.prank(user);
        stakingPool.stake(100 * 10**18);
        (uint256 amount, uint256 startTime) = stakingPool.stakes(user);
        assertEq(amount, 100 * 10**18);
        assertGt(startTime, 0);
    }

    function testWithdrawStake() public {
        vm.prank(user);
        stakingPool.stake(100 * 10**18);

        vm.warp(block.timestamp + 3 minutes);

        vm.prank(user);
        stakingPool.withdrawStake();

        uint256 expectedBalance = 500 * 10**18 + (100 * 10**18 * 6 / 100);
        assertEq(stakingToken.balanceOf(user), expectedBalance);
    }

    function testFailEarlyWithdrawal() public {
        vm.prank(user);
        stakingPool.stake(100 * 10**18);

        vm.warp(block.timestamp + 1 minutes);

        vm.prank(user);
        stakingPool.withdrawStake(); 
    }
}
