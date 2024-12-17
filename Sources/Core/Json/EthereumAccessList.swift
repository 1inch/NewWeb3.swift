import Foundation

public struct EthereumAccessList: Codable {
    public struct AccessListEntry: Codable {
        public let address: EthereumAddress
        public let storageKeys: [EthereumData]
    }

    public let accessList: [AccessListEntry]
    public let gasUsed: EthereumQuantity
}
