import Foundation

public extension Web3 {
    func clientVersion() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            clientVersion { response in
                continuation.resume(with: response._result)
            }
        }
    }
}

public extension Web3.Net {
    func version() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            version { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func peerCount() async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            peerCount { response in
                continuation.resume(with: response._result)
            }
        }
    }
}

public extension Web3.Eth {
    func protocolVersion() async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            protocolVersion { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func syncing() async throws -> EthereumSyncStatusObject {
        try await withCheckedThrowingContinuation { continuation in
            syncing { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func mining() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            mining { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func hashrate() async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            hashrate { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func gasPrice() async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            gasPrice { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func accounts() async throws -> [EthereumAddress] {
        try await withCheckedThrowingContinuation { continuation in
            accounts { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func blockNumber() async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            blockNumber { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getBalance(address: EthereumAddress, block: EthereumQuantityTag) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            getBalance(address: address, block: block) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getStorageAt(
        address: EthereumAddress,
        position: EthereumQuantity,
        block: EthereumQuantityTag
    ) async throws -> EthereumData {
        try await withCheckedThrowingContinuation { continuation in
            getStorageAt(address: address, position: position, block: block) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getTransactionCount(address: EthereumAddress, block: EthereumQuantityTag) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            getTransactionCount(address: address, block: block) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getBlockTransactionCountByHash(blockHash: EthereumData) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            getBlockTransactionCountByHash(blockHash: blockHash) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getBlockTransactionCountByNumber(block: EthereumQuantityTag) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            getBlockTransactionCountByNumber(block: block) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getUncleCountByBlockHash(blockHash: EthereumData) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            getUncleCountByBlockHash(blockHash: blockHash) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getUncleCountByBlockNumber(block: EthereumQuantityTag) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            getUncleCountByBlockNumber(block: block) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getCode(address: EthereumAddress, block: EthereumQuantityTag) async throws -> EthereumData {
        try await withCheckedThrowingContinuation { continuation in
            getCode(address: address, block: block) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func sendRawTransaction(transaction: EthereumSignedTransaction) async throws -> EthereumData {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try sendRawTransaction(transaction: transaction) { response in
                    continuation.resume(with: response._result)
                }
            }
            catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func sendTransaction(transaction: EthereumTransaction) async throws -> EthereumData {
        try await withCheckedThrowingContinuation { continuation in
            sendTransaction(transaction: transaction) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func call(call: EthereumCall, block: EthereumQuantityTag) async throws -> EthereumData {
        try await withCheckedThrowingContinuation { continuation in
            self.call(call: call, block: block) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func estimateGas(call: EthereumCall, block: EthereumQuantityTag?) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            estimateGas(call: call, block: block) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func createAccessList(
        call: EthereumCall,
        block: EthereumQuantityTag
    ) async throws -> EthereumAccessList {
        try await withCheckedThrowingContinuation { continuation in
            createAccessList(call: call, block: block) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getBlockByHash(blockHash: EthereumData, fullTransactionObjects: Bool) async throws -> EthereumBlockObject? {
        try await withCheckedThrowingContinuation { continuation in
            getBlockByHash(blockHash: blockHash, fullTransactionObjects: fullTransactionObjects) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getBlockByNumber(
        block: EthereumQuantityTag,
        fullTransactionObjects: Bool
    ) async throws -> EthereumBlockObject? {
        try await withCheckedThrowingContinuation { continuation in
            getBlockByNumber(block: block, fullTransactionObjects: fullTransactionObjects) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getTransactionByHash(transactionHash: EthereumData) async throws -> EthereumTransactionObject? {
        try await withCheckedThrowingContinuation { continuation in
            getTransactionByHash(transactionHash: transactionHash) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getTransactionByBlockHashAndIndex(
        blockHash: EthereumData,
        transactionIndex: EthereumQuantity
    ) async throws -> EthereumTransactionObject? {
        try await withCheckedThrowingContinuation { continuation in
            getTransactionByBlockHashAndIndex(blockHash: blockHash, transactionIndex: transactionIndex) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getTransactionByBlockNumberAndIndex(
        block: EthereumQuantityTag,
        transactionIndex: EthereumQuantity
    ) async throws -> EthereumTransactionObject? {
        try await withCheckedThrowingContinuation { continuation in
            getTransactionByBlockNumberAndIndex(block: block, transactionIndex: transactionIndex) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getTransactionReceipt(transactionHash: EthereumData) async throws -> EthereumTransactionReceiptObject? {
        try await withCheckedThrowingContinuation { continuation in
            getTransactionReceipt(transactionHash: transactionHash) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getUncleByBlockHashAndIndex(
        blockHash: EthereumData,
        uncleIndex: EthereumQuantity
    ) async throws -> EthereumBlockObject? {
        try await withCheckedThrowingContinuation { continuation in
            getUncleByBlockHashAndIndex(blockHash: blockHash, uncleIndex: uncleIndex) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getUncleByBlockNumberAndIndex(
        block: EthereumQuantityTag,
        uncleIndex: EthereumQuantity
    ) async throws -> EthereumBlockObject? {
        try await withCheckedThrowingContinuation { continuation in
            getUncleByBlockNumberAndIndex(block: block, uncleIndex: uncleIndex) { response in
                continuation.resume(with: response._result)
            }
        }
    }
    
    func getLogs(
        addresses: [EthereumAddress]?,
        topics: [[EthereumData]]?,
        fromBlock: EthereumQuantityTag,
        toBlock: EthereumQuantityTag
    ) async throws -> [EthereumLogObject] {
        try await withCheckedThrowingContinuation { continuation in
            getLogs(addresses: addresses, topics: topics, fromBlock: fromBlock, toBlock: toBlock) { response in
                continuation.resume(with: response._result)
            }
        }
    }
}

fileprivate extension Web3Response {
    var _result: Swift.Result<Result, Swift.Error> {
        switch status {
        case let .success(responseResult):
            return .success(responseResult)
        case let .failure(error):
            return .failure(error)
        }
    }
}
