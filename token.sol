// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenVesting {
    address public owner;
    mapping(address => Vesting) public vestingSchedules;
    
    struct Vesting {
        uint256 amount;
        uint256 releaseTime;
        uint256 released;
    }

    event TokensVested(address indexed beneficiary, uint256 amount, uint256 releaseTime);
    event TokensReleased(address indexed beneficiary, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to add a new vesting schedule
    function addVestingSchedule(address _beneficiary, uint256 _amount, uint256 _releaseTime) public onlyOwner {
        require(_beneficiary != address(0), "Invalid beneficiary address");
        require(_amount > 0, "Amount should be greater than 0");
        require(_releaseTime > block.timestamp, "Release time must be in the future");

        vestingSchedules[_beneficiary] = Vesting({
            amount: _amount,
            releaseTime: _releaseTime,
            released: 0
        });

        emit TokensVested(_beneficiary, _amount, _releaseTime);
    }

    // Function to release vested tokens
    function releaseTokens() public {
        Vesting storage vesting = vestingSchedules[msg.sender];

        require(vesting.amount > 0, "No vesting schedule found");
        require(block.timestamp >= vesting.releaseTime, "Tokens are not yet vested");
        require(vesting.released < vesting.amount, "All tokens have been released");

        uint256 releasableAmount = vesting.amount - vesting.released;
        vesting.released += releasableAmount;

        payable(msg.sender).transfer(releasableAmount);
        emit TokensReleased(msg.sender, releasableAmount);
    }

    // Function to withdraw any extra tokens (for contract owner)
    function withdraw(uint256 _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance in contract");
        payable(owner).transfer(_amount);
    }

    // Receive function to accept tokens into the contract
    receive() external payable {}
}
