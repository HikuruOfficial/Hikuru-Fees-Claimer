// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract FeeClaimer is ReentrancyGuard, Pausable {

    mapping(address => mapping (address => uint256)) private balances;
    mapping(address => mapping (address => uint256)) private totalBalances;
    mapping(address => mapping (uint8 => uint256)) private totalTransactions;
    mapping(address => bool) private claiming;
    // IBlast public constant BLAST = IBlast(0x4300000000000000000000000000000000000002);
    mapping(address => bool) private _hikuruOwner;
    mapping(address => bool) private _allowDeposit;
    address public hikuruPiggyBank;

    bool public isClaimEnable = true;


    event Deposit(address indexed user, address token, uint256 amount, uint8 rtype);
    event FeesClaimed(address indexed user, address token, uint256 amount);
    event ClaimEnabledUpdated(bool isEnabled);


    modifier onlyHikuruOwner() {
        require(_hikuruOwner[msg.sender], "Caller is not an owner");
        _; // Continue execution
    }

    modifier onlyAllowDeposit() {
        require(_allowDeposit[msg.sender], "Caller is not allowed to deposit");
        _; // Continue execution
    }

    modifier claimNotInProgress() {
        require(!claiming[msg.sender], "Claim operation already in progress");
        _;
    }

    constructor(address _initialOwner, address _hikuruPiggyBank) {
        _hikuruOwner[_initialOwner] = true;
        _allowDeposit[_initialOwner] = true;
        hikuruPiggyBank = _hikuruPiggyBank;

        // BLAST.configureClaimableYield();
        // BLAST.configureClaimableGas(); 
    }

    // deposit native tokens
    function deposit(address _user, uint8 _type) external payable returns (bool) {
        require(_user != address(0), "User address cannot be zero");

        // to not fail the transaction if the user is not allowed to deposit
        if(msg.value>0){
            balances[_user][address(0)] += msg.value;
            totalBalances[_user][address(0)] += msg.value;
            totalTransactions[_user][_type] += 1;
            emit Deposit(_user, address(0), msg.value, _type);
        }

        return true;
    }

    // deposit erc20 tokens
    function depositERC20(address _user, address _token, uint256 _amount, uint8 _type) external onlyAllowDeposit returns (bool) {
        require(_user != address(0), "User address cannot be zero");

        if(_amount>0){
            balances[_user][_token] += _amount;
            totalBalances[_user][_token] += _amount;
            totalTransactions[_user][_type] += 1;

            emit Deposit(_user, _token, _amount, _type);
        }
        return true;
    }



    // Claim all the all tokens
    function claimTokens(address[] calldata _tokens) public nonReentrant whenNotPaused claimNotInProgress {
        require(isClaimEnable, "Claiming is disabled");
        claiming[msg.sender] = true;

        for (uint i = 0; i < _tokens.length; i++) {
            if (_tokens[i] == address(0)) {
                // Claim native tokens
                uint256 amount = balances[msg.sender][address(0)];
                if(amount > 0){
                    balances[msg.sender][address(0)] = 0; // Reset balance before transfer
                    (bool sent, ) = msg.sender.call{value: amount}("");
                    require(sent, "Failed to send Ether");
                    emit FeesClaimed(msg.sender, address(0), amount);
                }
            } else {
                // Claim ERC20 tokens
                address tokenAddress = _tokens[i];
                uint256 amount = balances[msg.sender][tokenAddress];
                if (amount > 0) {
                    balances[msg.sender][tokenAddress] = 0; // Reset balance before transfer
                    IERC20 token = IERC20(tokenAddress);
                    require(token.balanceOf(address(this)) >= amount, "Insufficient token contract balance");
                    require(token.transfer(msg.sender, amount), "Token transfer failed");
                    emit FeesClaimed(msg.sender, tokenAddress, amount);
                }
            }
        }

        claiming[msg.sender] = false;
    }


    function getBalances(address _user, address[] calldata _tokens) public view returns (uint256[] memory) {
        uint256[] memory _balances = new uint256[](_tokens.length);
        for (uint i = 0; i < _tokens.length; i++) {
            _balances[i] = balances[_user][_tokens[i]];
        }
        return _balances;
    }

    function getTotalBalances(address _user, address[] calldata _tokens) public view returns (uint256[] memory) {
        uint256[] memory _balances = new uint256[](_tokens.length);
        for (uint i = 0; i < _tokens.length; i++) {
            _balances[i] = totalBalances[_user][_tokens[i]];
        }
        return _balances;
    }

    function getTotalTransactions(address _user,  uint8 _type) public view returns (uint256) {
        return totalTransactions[_user][_type];
    }

    function isOwner(address _owner) public view returns (bool) {
        return _hikuruOwner[_owner];
    }

    function isAllowedToDeposit(address _owner) public view returns (bool) {
        return _allowDeposit[_owner];
    }

    function setHikuruOwner(address _owner, bool _isOwner) public onlyHikuruOwner {
        _hikuruOwner[_owner] = _isOwner;
    }

    function setAllowDeposit(address _owner, bool _isOwner) public onlyHikuruOwner {
        _allowDeposit[_owner] = _isOwner;
    }

    // function setClaimEnabled(bool _isEnabled) public onlyHikuruOwner {
    //     isClaimEnable = _isEnabled;
    // }


    // function claimAllYield() external onlyHikuruOwner {
    //     // allow only the owner to claim the yield
    //     BLAST.claimAllYield(address(this), hikuruPiggyBank);
    // }

    // function claimMyContractsGas() external onlyHikuruOwner {
    //     // allow only the owner to claim the gas
    //     BLAST.claimAllGas(address(this), hikuruPiggyBank);
    // }

    // Use the pause() and unpause() functions inherited from Pausable for emergency stops
    function pause() public onlyHikuruOwner {
        _pause();
    }
    function unpause() public onlyHikuruOwner {
        _unpause();
    }

}

// interface IBlast{
//     // base configuration options
//     function configureClaimableYield() external;
//     function configureClaimableGas() external;
//     // claim yield
//     function claimAllYield(address contractAddress, address recipientOfYield) external returns (uint256);
//     // claim gas
//     function claimAllGas(address contractAddress, address recipientOfGas) external returns (uint256);
// }
