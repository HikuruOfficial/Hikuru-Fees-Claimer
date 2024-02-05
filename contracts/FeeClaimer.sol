// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract FeeClaimer is ReentrancyGuard {

    mapping(address => uint256) private balances;
    mapping(address => uint256) private totalBalances;
    mapping(address => uint256) private totalTransactions;
    mapping(address => bool) private claiming;
    address public hikuruOwner;

    bool public isClaimEnable = true;

    event Deposited(address indexed user, uint256 amount);
    event FeesClaimed(address indexed user,uint256 amount);
    event ClaimEnabledUpdated(bool isEnabled);

    modifier onlyHikuruOwner() {
        require(hikuruOwner==msg.sender, "Caller is not an owner");
        _; // Continue execution
    }

    constructor(address _initialOwner) {
        hikuruOwner = _initialOwner;
    }

    function deposit(address _user, uint256 _amount) public payable returns (bool) {
        require(_amount > 0, "Amount must be greater than 0");
        require(_user != address(0), "User address cannot be zero");
        require(msg.value >= _amount, "Sent ether does not match the specified amount");

        balances[_user] += msg.value;
        totalBalances[_user] += msg.value;
        totalTransactions[_user] += 1;

        emit Deposited(_user, msg.value);

        return true;
    }


    function claimAllFees() public nonReentrant{
        require(isClaimEnable, "Claiming is disabled");
        require(!claiming[msg.sender], "Claim operation already in progress");
        
        uint256 _amount = balances[msg.sender];
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(_amount > 0, "Amount must be greater than 0");

        claiming[msg.sender] = true;
        balances[msg.sender] = 0;
    
        require(address(this).balance >= _amount, "Insufficient contract balance");
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send Ether");

        claiming[msg.sender] = false;
        emit FeesClaimed(msg.sender, _amount);
    }


    function getBalance(address _user) public view returns (uint256) {
        return balances[_user];
    }

    function getTotalBalance(address _user) public view returns (uint256) {
        return totalBalances[_user];
    }

    function getTotalTransactions(address _user) public view returns (uint256) {
        return totalTransactions[_user];
    }

    function setClaimEnabled(bool _isEnabled) public onlyHikuruOwner {
        isClaimEnable = _isEnabled;
    }

}
