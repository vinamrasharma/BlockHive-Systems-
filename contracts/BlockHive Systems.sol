@title TokenAuditTrail
/@dev This contract tracks transfers of an ERC20-like token and stores an immutable log of each transaction.
contract TokenAuditTrail {

    address public admin;

    struct TransferRecord {
        address from;
        address to;
        uint256 amount;
        uint256 timestamp;
        bytes32 txHash;  Array to store all transfer records immutably
    TransferRecord[] public transferRecords;

    @notice Logs a token transfer event immutably
    /@param to Address tokens sent to
    /@param txHash The hash of the original token transfer transaction
    function logTransfer(address from, address to, uint256 amount, bytes32 txHash) external onlyAdmin {
        TransferRecord memory record = TransferRecord({
            from: from,
            to: to,
            amount: amount,
            timestamp: block.timestamp,
            txHash: txHash
        });
        transferRecords.push(record);

        emit TransferLogged(from, to, amount, block.timestamp, txHash);
    }

    /@notice Returns a transfer record at a specific index
    /// @param index The index of the transfer record
    function getTransferRecord(uint256 index) external view returns (TransferRecord memory) {
        require(index < transferRecords.length, "Index out of bounds");
        return transferRecords[index];
    }
}
// 
update
// 
