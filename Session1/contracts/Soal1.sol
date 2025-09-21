// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title BasedToken
 * @dev ERC20 token with role-based access, pausing, and burnable features
 * Use cases:
 * - Fungible tokens (utility token, governance token, etc.)
 */
contract BasedToken is ERC20, ERC20Burnable, Pausable, AccessControl {
    // TODO: Define role constants
    //bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    //bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    mapping(address => bool) public blacklisted;   // ban certain users
    mapping(address => uint256) public lastClaim;  // track last reward claim

    constructor(uint256 initialSupply) ERC20("BasedToken", "BASED") {
        // TODO: Grant roles
        // 1. Grant DEFAULT_ADMIN_ROLE to deployer
        // 2. Grant MINTER_ROLE to deployer
        // 3. Grant PAUSER_ROLE to deployer
        // 4. Mint initial supply to deployer

        //initial supply itu dalam bentuk WEI
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _mint(msg.sender, initialSupply);
    }

    /**
     * @dev Mint new tokens
     */
    function mint(address to, uint256 amount) public {
        // TODO: Only MINTER_ROLE can call
        require(hasRole(MINTER_ROLE, msg.sender), "Penyusup Minter!!!");
        _mint(to, amount);
    }

    /**
     * @dev Pause all transfers
     */
    function pause() public {
        // TODO: Only PAUSER_ROLE can call
        require(hasRole(PAUSER_ROLE, msg.sender), "Penyusup Pauser!!!");
        _pause();
    }

    function unpause() public {
        // TODO: Only PAUSER_ROLE can call
        require(hasRole(PAUSER_ROLE, msg.sender), "Penyusup Unpauser!!!");
        _unpause();
    }
    
    /**
     * @dev Blacklist a user (only admin)
     */
    function setBlacklist(address user, bool status) public {
        // TODO: Only DEFAULT_ADMIN_ROLE can call
        // Update mapping
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "bukan admin");
        blacklisted[user]=status;
    }

    /**
     * @dev Simple daily reward claim
     */
    function claimReward() public {
        // TODO:
        // 1. Check if 1 day passed since last claim
        // 2. Mint small reward to msg.sender
        // 3. Update lastClaim[msg.sender]
        require(block.timestamp >= lastClaim[msg.sender] + 1 days, "jan nyolong bang");
        
        _mint(msg.sender, 1 * 10**decimals()); //10 BASED per hari
        // _mint(msg.sender, 1 * 10**18); //begini juga bisa


        lastClaim[msg.sender] = block.timestamp;
    }

    /**
     * @dev Hook to block transfers when paused
     */
    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override {
        // TODO: Add pause check
        // super._update(from, to, amount);
        _requireNotPaused();
        super._update(from, to, amount);
    }
}
