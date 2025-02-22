// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingPool is Ownable {
    IERC20 public stakingToken;
    uint256 public constant REWARD = 2;
    uint256 public constant STAKE_DURATION = 2 minutes;

    struct StakeInfo {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => StakeInfo) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward);

    constructor(address _stakingToken) Ownable(msg.sender) {
        stakingToken = IERC20(_stakingToken);
    }

    function stake(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than zero");
        require(
            stakingToken.balanceOf(msg.sender) >= _amount,
            "Insufficient token balance"
        );
        require(
            stakingToken.allowance(msg.sender, address(this)) >= _amount,
            "Token allowance too low"
        );
        require(stakes[msg.sender].amount == 0, "Already staked");

        stakingToken.transferFrom(msg.sender, address(this), _amount);
        stakes[msg.sender] = StakeInfo({
            amount: _amount,
            startTime: block.timestamp
        });
        emit Staked(msg.sender, _amount);
    }

    function withdrawStake() external {
        StakeInfo storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No active stake");
        require(
            block.timestamp >= userStake.startTime + STAKE_DURATION,
            "Stake duration not met"
        );

        uint256 stakingTime = (block.timestamp - userStake.startTime) / 60;
        uint256 reward = (userStake.amount * stakingTime * REWARD) / 100;

        uint256 totalAmount = userStake.amount + reward;
        delete stakes[msg.sender];
        stakingToken.transfer(msg.sender, totalAmount);
        emit Withdrawn(msg.sender, userStake.amount, reward);
    }
}
