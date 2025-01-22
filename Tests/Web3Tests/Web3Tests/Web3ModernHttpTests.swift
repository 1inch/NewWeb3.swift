import XCTest
import BigInt
@testable import Web3
#if canImport(Web3ContractABI)
@testable import Web3ContractABI
#endif

class Web3ModernHttpTests: XCTestCase {
    let web3 = Web3(rpcURL: Web3HttpTests.infuraUrl)
    
    func testGasEstimationWithAccessList() async throws {
        let weth = try EthereumAddress(hex: "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", eip55: false)
        let wallet = try EthereumAddress(hex: "0x1d23118d0dd260547610b5326c2e62be7f5f6faa", eip55: false)
        let ethAmount = BigUInt(100)
        let value = EthereumQuantity(quantity: ethAmount)
        
        let callGeneric = EthereumCall(
            from: wallet,
            to: weth,
            value: value
        )
        
        let block = EthereumQuantityTag.latest
        
        let accessList: EthereumAccessList = await {
            do {
                // This will fail on infura node but works on 1inch node
                return try await web3.eth.createAccessList(call: callGeneric, block: block)
            }
            catch {
                return EthereumAccessList(
                    accessList: [
                        try! .init(
                            address: EthereumAddress(hex: "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2", eip55: false),
                            storageKeys: [
                                EthereumData(
                                    ethereumValue: "0xc3bacac112bd5756961063151840c3fb4b8b4bf609182cbcfcbbd7729cd52179"
                                )
                            ]
                        )
                    ], gasUsed: EthereumQuantity(quantity: 29931))
            }
        }()
        
        let callAccessList = EthereumCall(
            from: wallet,
            to: weth,
            value: value,
            accessList: accessList.accessList
        )
        
        let estimatedGeneric = try await web3.eth.estimateGas(call: callGeneric, block: block)
        let estimatedAccessList = try await web3.eth.estimateGas(call: callAccessList, block: block)
        
        print("Access list's gas used: \(accessList.gasUsed.quantity)")
        print("Estimated generic gas: \(estimatedGeneric.quantity)")
        print("Estimated access list gas: \(estimatedAccessList.quantity)")
        
        // access list should have been cheaper
        XCTAssert(accessList.gasUsed.quantity > estimatedGeneric.quantity)
        
        // thus, adding an access list increases the gas cost ¯\_(ツ)_/¯
        XCTAssert(estimatedAccessList.quantity > estimatedGeneric.quantity)
    }
}
