import Foundation
import BigInt
import XCTest
import AnyCodable

@testable import Web3
@testable import Web3ContractABI

struct TestCaseSolidityHash: Codable {
    let name: String
    let types: [String]
    let keccak256: String
    let ripemd160: String
    let sha256: String
    let values: [AnyCodable]
}

class SolidityPackedTests: XCTestCase {
    // https://github.com/ethers-io/ethers.js/blob/72c2182d01afa855d131e82635dca3da063cfb31/testcases/solidity-hashes.json.gz
    func loadTestCases() throws -> [TestCaseSolidityHash] {
        let testBundle = Bundle(for: SolidityPackedTests.self)
        guard
            let bundleURL = testBundle.url(forResource: "Web3_Web3Tests", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL),
            let url = bundle.url(forResource: "solidity-hashes", withExtension: "json") else {
            throw NSError(domain: "FileNotFound", code: 1)
        }
        
        let data = try Data(contentsOf: url)
        let testCases = try JSONDecoder().decode([TestCaseSolidityHash].self, from: data)
        
        return testCases
    }
    
    func testSolidityHashFunction() throws {
        let testCases = try loadTestCases()
        for test in testCases {
            let types = test.types
            let values = test.values.map(\.value)
            
            let keccak256 = try SolidityPacked.solidityPackedKeccak256(types: types, values: values)
            XCTAssertEqual(keccak256, test.keccak256, "Failed keccak256 \(test.name)")
            
            let sha256 = try SolidityPacked.solidityPackedSha256(types: types, values: values)
            XCTAssertEqual(sha256, test.sha256, "Failed sha256 \(test.name)")
        }
    }
    
    func testBadTypes() throws {
        struct BadType {
            let types: [String]
            let values: [Any]
        }
        
        let badTypes = [
            BadType(types: ["uint5"], values: [1]),
            BadType(types: ["bytes0"], values: ["0x"]),
            BadType(types: ["blorb"], values: [false])
        ]
        
        for badType in badTypes {
            XCTAssertThrowsError(try SolidityPacked.solidityPacked(types: badType.types, values: badType.values))
        }
    }
}
