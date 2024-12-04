// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EvaToken is ERC20 {

    uint256 public constant SUPPLY = 167743518000000000000000000;
    address public constant evaluatorAddress = 0xB8d4fDEe700263F6f07800AECd702C3D0D74E601;
    address private owner;
    
    mapping(address => bool) private allowList;
    mapping(address => uint256) private userTiers;

    modifier onlyAllowed() {
        require(allowList[msg.sender], "Not on the allow-list");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() ERC20("EvaToken", "zvxrllie") {
        _mint(msg.sender, SUPPLY);
        owner = msg.sender;

        allowList[evaluatorAddress] = true;
        userTiers[evaluatorAddress] = 2;

    }

    function getToken() external onlyAllowed returns(bool) {
        uint256 amount = 1000; 
        _mint(msg.sender, amount);
        return true;
    }

    function buyToken() external payable onlyAllowed returns(bool) {
        require(msg.value > 0, "Must send ETH to buy tokens");
        uint256 multiplier = getMultiplierForTier(userTiers[msg.sender]);
        uint256 tokensToMint = msg.value * multiplier;
        _mint(msg.sender, tokensToMint);
        return true;
    }

    function addToAllowList(address _user) external onlyOwner {
        allowList[_user] = true;
    }

    function removeFromAllowList(address _user) external onlyOwner {
        allowList[_user] = false;
    }

    function isCustomerWhiteListed(address customerAddress) public view returns (bool) {
        return allowList[customerAddress];
    }
    
    function customerTierLevel(address _user) external view returns (uint256) {
        return userTiers[_user];
    }

    function getMultiplierForTier(uint256 _tier) public pure returns (uint256) {
        if (_tier == 1) {
            return 8; 
        } else if (_tier == 2) {
            return 16; 
        } else if (_tier == 3) {
            return 24; 
        } else {
            return 0; 
        }
    }
}
