//
//  EthereumAddressTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 05.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3

class EthereumAddressTests: QuickSpec {

    override func spec() {
        describe("ethereum address checks") {
            context("without eip55 checksum") {

                it("should be valid ethereum addresses") {
                    let a = try? EthereumAddress(hex: "0xf5745ddac99ee7b70518a9035c00cfd63c490b1d", eip55: false)
                    expect(a).toNot(beNil())
                    expect(a?.stringAddress(eip55: false)) == "0xf5745ddac99ee7b70518a9035c00cfd63c490b1d"

                    let a2 = try? EthereumAddress(hex: "f5745ddac99ee7b70518a9035c00cfd63c490b1d", eip55: false)
                    expect(a2).toNot(beNil())
                    expect(a2?.stringAddress(eip55: false)) == "0xf5745ddac99ee7b70518a9035c00cfd63c490b1d"

                    expect(a?.rawAddress) == a2?.rawAddress

                    let randomMixedCase = try? EthereumAddress(
                        hex: "0xf5745dDac99Ee7b70518A9035C00cfd63c490b1D",
                        eip55: false
                    )
                    expect(randomMixedCase).toNot(beNil())
                    expect(randomMixedCase?.stringAddress(eip55: false)) == "0xf5745ddac99ee7b70518a9035c00cfd63c490b1d"

                    let zero = try? EthereumAddress(hex: "0x0000000000000000000000000000000000000000", eip55: false)
                    expect(zero).toNot(beNil())
                    expect(zero?.stringAddress(eip55: false)) == "0x0000000000000000000000000000000000000000"
                    expect(zero?.rawAddress) == [
                        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                    ]
                }

                it("should be invalid ethereum addresses") {
                    expect { try EthereumAddress(hex: "0xf5745ddac99ee7b70518a9035c00cfd63c490b1dd", eip55: false) }
                        .to(throwError(EthereumAddress.Error.addressMalformed))

                    expect { try EthereumAddress(hex: "f5745ddac99ee7b70518a9035c00cfd63c490b1", eip55: false) }
                        .to(throwError(EthereumAddress.Error.addressMalformed))

                    expect { try EthereumAddress(hex: "0xf5745ddac99ee7b70518a9035c00cfd63c490b1", eip55: false) }
                        .to(throwError(EthereumAddress.Error.addressMalformed))

                    expect { try EthereumAddress(hex: "0xf5745ddac99ee7b70518a9035c00cfd63c490b", eip55: false) }
                        .to(throwError(EthereumAddress.Error.addressMalformed))

                    expect { try EthereumAddress(hex: "f5745ddac99ee7b70518a9035c00cfd63c490b1ddd", eip55: false) }
                        .to(throwError(EthereumAddress.Error.addressMalformed))
                }
            }

            context("with eip55 checksum") {

                it("should be valid checksumed ethereum addresses") {
                    let a = try? EthereumAddress(hex: "0xf5745DDAC99EE7B70518A9035c00cfD63C490B1D", eip55: true)
                    expect(a).toNot(beNil())
                    expect(a?.stringAddress(eip55: true)) == "0xf5745DDAC99EE7B70518A9035c00cfD63C490B1D"

                    let a2 = try? EthereumAddress(hex: "f5745DDAC99EE7B70518A9035c00cfD63C490B1D", eip55: true)
                    expect(a2).toNot(beNil())
                    expect(a2?.stringAddress(eip55: true)) == "0xf5745DDAC99EE7B70518A9035c00cfD63C490B1D"

                    expect(a?.rawAddress) == a2?.rawAddress
                }

                it("should be invalid checksumed ethereum addresses") {
                    expect { try EthereumAddress(hex: "0xf5745DDAC99EE7B70518A9035c00cfD63C490B1d", eip55: true) }
                        .to(throwError(EthereumAddress.Error.checksumWrong))

                    expect { try EthereumAddress(hex: "0xf5745dDAC99EE7B70518A9035c00cfD63C490B1D", eip55: true) }
                        .to(throwError(EthereumAddress.Error.checksumWrong))

                    expect { try EthereumAddress(hex: "0xf5745ddac99ee7b70518a9035c00cfd63c490b1d", eip55: true) }
                        .to(throwError(EthereumAddress.Error.checksumWrong))
                }
            }
        }
    }
}
