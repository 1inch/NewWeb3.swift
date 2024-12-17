import Foundation
import Web3
import Collections

public extension Web3 {
    enum Error: Swift.Error {
        case unknownError
    }
}

public extension SolidityFunctionHandler {
    func call(
        _ ethCall: EthereumCall,
        outputs: [SolidityFunctionParameter],
        block: EthereumQuantityTag
    ) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation { continuation in
            call(ethCall, outputs: outputs, block: block) { result, error in
                if let result {
                    continuation.resume(returning: result)
                }
                else {
                    continuation.resume(throwing: error ?? Web3.Error.unknownError)
                }
            }
        }
    }
    
    func send(_ transaction: EthereumTransaction) async throws -> EthereumData {
        try await withCheckedThrowingContinuation { continuation in
            send(transaction) { result, error in
                if let result {
                    continuation.resume(returning: result)
                }
                else {
                    continuation.resume(throwing: error ?? Web3.Error.unknownError)
                }
            }
        }
    }
    
    func estimateGas(_ call: EthereumCall, block: EthereumQuantityTag?) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            estimateGas(call, block: block) { result, error in
                if let result {
                    continuation.resume(returning: result)
                }
                else {
                    continuation.resume(throwing: error ?? Web3.Error.unknownError)
                }
            }
        }
    }
    
    func createAccessList(_ call: EthereumCall, block: EthereumQuantityTag?) async throws -> EthereumAccessList {
        try await withCheckedThrowingContinuation { continuation in
            createAccessList(call, block: block) { result, error in
                if let result {
                    continuation.resume(returning: result)
                }
                else {
                    continuation.resume(throwing: error ?? Web3.Error.unknownError)
                }
            }
        }
    }
}

public extension SolidityInvocation {
    /// Read data from the blockchain. Only available for constant functions.
    func call(block: EthereumQuantityTag) async throws -> [String: Any] {
        try await withCheckedThrowingContinuation { continuation in
            call(block: block) { result, error in
                if let result {
                    continuation.resume(returning: result)
                }
                else {
                    continuation.resume(throwing: error ?? Web3.Error.unknownError)
                }
            }
        }
    }
    
    /// Write data to the blockchain. Only available for non-constant functions.
    func send(
        nonce: EthereumQuantity?,
        gasPrice: EthereumQuantity?,
        maxFeePerGas: EthereumQuantity?,
        maxPriorityFeePerGas: EthereumQuantity?,
        gasLimit: EthereumQuantity?,
        from: EthereumAddress,
        value: EthereumQuantity?,
        accessList: OrderedDictionary<EthereumAddress, [EthereumData]>,
        transactionType: EthereumTransaction.TransactionType
    ) async throws -> EthereumData {
        try await withCheckedThrowingContinuation { continuation in
            send(
                nonce: nonce,
                gasPrice: gasPrice,
                maxFeePerGas: maxFeePerGas,
                maxPriorityFeePerGas: maxPriorityFeePerGas,
                gasLimit: gasLimit,
                from: from,
                value: value,
                accessList: accessList,
                transactionType: transactionType
            ) { result, error in
                if let result {
                    continuation.resume(returning: result)
                }
                else {
                    continuation.resume(throwing: error ?? Web3.Error.unknownError)
                }
            }
        }
    }
    
    /// Estimate how much gas is needed to execute this transaction.
    func estimateGas(
        from: EthereumAddress?,
        gas: EthereumQuantity?,
        gasPrice: EthereumQuantity?,
        maxPriorityFeePerGas: EthereumQuantity?,
        maxFeePerGas: EthereumQuantity?,
        value: EthereumQuantity?,
        block: EthereumQuantityTag?
    ) async throws -> EthereumQuantity {
        try await withCheckedThrowingContinuation { continuation in
            estimateGas(
                from: from,
                gas: gas,
                gasPrice: gasPrice,
                maxPriorityFeePerGas: maxPriorityFeePerGas,
                maxFeePerGas: maxFeePerGas,
                value: value,
                block: block
            ) { result, error in
                if let result {
                    continuation.resume(returning: result)
                }
                else {
                    continuation.resume(throwing: error ?? Web3.Error.unknownError)
                }
            }
        }
    }
    
    /// Create an access list for this transaction.
    func createAccessList(
        from: EthereumAddress?,
        gas: EthereumQuantity?,
        gasPrice: EthereumQuantity?,
        maxPriorityFeePerGas: EthereumQuantity?,
        maxFeePerGas: EthereumQuantity?,
        value: EthereumQuantity?,
        data: EthereumData?,
        block: EthereumQuantityTag?
    ) async throws -> EthereumAccessList {
        try await withCheckedThrowingContinuation { continuation in
            createAccessList(
                from: from,
                gas: gas,
                gasPrice: gasPrice,
                maxPriorityFeePerGas: maxPriorityFeePerGas,
                maxFeePerGas: maxFeePerGas,
                value: value,
                block: block
            ) { result, error in
                if let result {
                    continuation.resume(returning: result)
                }
                else {
                    continuation.resume(throwing: error ?? Web3.Error.unknownError)
                }
            }
        }
    }
}
