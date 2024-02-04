// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract FeeClaimer is ReentrancyGuard {
    using SafeMath for uint256;

    mapping(address => uint256) private balances;
    mapping(address => uint256) private totalBalances;
    mapping(address => uint256) private totalTransactions;
    mapping(address => bool) private claiming;
    address public hikuruOwner;

    bool public isClaimEnable = true;

    event Deposited(address indexed user, uint256 amount);
    event FeesClaimed(address indexed user,uint256 amount);

    modifier onlyHikuruOwner() {
        require(hikuruOwner==msg.sender, "Caller is not an owner");
        _; // Continue execution
    }

    constructor(address _initialOwner) {
        hikuruOwner = _initialOwner;
    }

    function deposit(address _user, uint256 _amount) public payable {
        require(_amount > 0, "Amount must be greater than 0");
        require(_user != address(0), "User address cannot be zero");

        // If the token is the native currency (e.g., ETH), the contract should already have received the ETH
        require(msg.value >= _amount, "Sent ether does not match the specified amount");

        balances[_user] = balances[_user].add(_amount);
        totalBalances[_user] = totalBalances[_user].add(_amount);
        totalTransactions[_user] = totalTransactions[_user].add(1);

        emit Deposited(_user, _amount);
    }

    function claimAllFees() public nonReentrant{
        require(isClaimEnable, "Claiming is disabled");
        require(!claiming[msg.sender], "Claim operation already in progress");
        
        uint256 _amount = balances[msg.sender];
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(_amount > 0, "Amount must be greater than 0");

        claiming[msg.sender] = true;
        balances[msg.sender] = balances[msg.sender].sub(_amount);
    
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

    // Fallback function to accept ether
    // receive() external payable {
    //     if (msg.value > 0) {
    //         deposit(address(0), msg.value);
    //     }
    // }
}
