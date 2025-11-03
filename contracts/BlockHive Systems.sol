// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title BlockHive Systems
 * @notice A decentralized data collaboration hub enabling users to securely store, verify,
 *         and share digital assets or datasets on-chain with full transparency.
 */
contract Project {
    address public admin;
    uint256 public datasetCount;

    struct DataSet {
        uint256 id;
        address owner;
        string dataHash;
        string description;
        uint256 timestamp;
        bool verified;
    }

    mapping(uint256 => DataSet) public datasets;

    event DataSetAdded(uint256 indexed id, address indexed owner, string dataHash, string description);
    event DataSetVerified(uint256 indexed id, address indexed verifier);
    event OwnershipTransferred(uint256 indexed id, address indexed oldOwner, address indexed newOwner);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyOwner(uint256 _id) {
        require(datasets[_id].owner == msg.sender, "Not dataset owner");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Add a new dataset to BlockHive
     * @param _dataHash IPFS or SHA256 hash of the dataset
     * @param _description Short description of the dataset
     */
    function addDataSet(string memory _dataHash, string memory _description) external {
        require(bytes(_dataHash).length > 0, "Data hash required");
        require(bytes(_description).length > 0, "Description required");

        datasetCount++;
        datasets[datasetCount] = DataSet(
            datasetCount,
            msg.sender,
            _dataHash,
            _description,
            block.timestamp,
            false
        );

        emit DataSetAdded(datasetCount, msg.sender, _dataHash, _description);
    }

    /**
     * @notice Admin verifies dataset authenticity
     * @param _id Dataset ID
     */
    function verifyDataSet(uint256 _id) external onlyAdmin {
        require(_id > 0 && _id <= datasetCount, "Invalid dataset ID");
        require(!datasets[_id].verified, "Already verified");

        datasets[_id].verified = true;
        emit DataSetVerified(_id, msg.sender);
    }

    /**
     * @notice Transfer ownership of dataset
     * @param _id Dataset ID
     * @param _newOwner Address of new dataset owner
     */
    function transferOwnership(uint256 _id, address _newOwner) external onlyOwner(_id) {
        require(_newOwner != address(0), "Invalid new owner");
        address oldOwner = datasets[_id].owner;
        datasets[_id].owner = _newOwner;

        emit OwnershipTransferred(_id, oldOwner, _newOwner);
    }

    /**
     * @notice View dataset details
     * @param _id Dataset ID
     */
    function getDataSet(uint256 _id) external view returns (DataSet memory) {
        require(_id > 0 && _id <= datasetCount, "Invalid dataset ID");
        return datasets[_id];
    }
}
