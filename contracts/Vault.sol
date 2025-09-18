// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockchainEVault {
    struct VaultItem {
        string encryptedData; // Encrypted string (AES/other encryption handled off-chain)
        uint256 timestamp;
    }

    // Mapping of user address to their vault data
    mapping(address => VaultItem[]) private vaults;

    // Event logs
    event ItemAdded(address indexed user, uint256 index, uint256 timestamp);
    event ItemUpdated(address indexed user, uint256 index, uint256 timestamp);
    event ItemDeleted(address indexed user, uint256 index, uint256 timestamp);

    // Add new data to vault
    function addItem(string memory _encryptedData) public {
        vaults[msg.sender].push(VaultItem(_encryptedData, block.timestamp));
        emit ItemAdded(msg.sender, vaults[msg.sender].length - 1, block.timestamp);
    }

    // Get all items from vault (only owner can access)
    function getMyVault() public view returns (VaultItem[] memory) {
        return vaults[msg.sender];
    }

    // Update an existing item
    function updateItem(uint256 index, string memory _newEncryptedData) public {
        require(index < vaults[msg.sender].length, "Invalid index");
        vaults[msg.sender][index].encryptedData = _newEncryptedData;
        vaults[msg.sender][index].timestamp = block.timestamp;
        emit ItemUpdated(msg.sender, index, block.timestamp);
    }

    // Delete an item (set to empty)
    function deleteItem(uint256 index) public {
        require(index < vaults[msg.sender].length, "Invalid index");
        delete vaults[msg.sender][index];
        emit ItemDeleted(msg.sender, index, block.timestamp);
    }
}
