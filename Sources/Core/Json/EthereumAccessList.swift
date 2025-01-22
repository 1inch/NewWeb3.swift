import Foundation
import Collections

public struct EthereumAccessList: Codable {
    public typealias AccessList = [AccessListEntry]
    
    public struct AccessListEntry: Codable {
        public let address: EthereumAddress
        public let storageKeys: [EthereumData]
    }
    
    public let accessList: AccessList
    public let gasUsed: EthereumQuantity
    
    public init(accessList: AccessList, gasUsed: EthereumQuantity) {
        self.accessList = accessList
        self.gasUsed = gasUsed
    }
}

// MARK: - Hashable

extension EthereumAccessList.AccessListEntry: Hashable {}

extension EthereumAccessList: Hashable {}

// MARK: - Helpers

public extension EthereumAccessList {
    var asDictionary: OrderedDictionary<EthereumAddress, [EthereumData]> {
        var dict = OrderedDictionary<EthereumAddress, [EthereumData]>()
        for entry in accessList {
            dict[entry.address] = entry.storageKeys
        }
        return dict
    }
}
