import Foundation
import Collections

public struct EthereumAccessList: Codable {
    public struct AccessListEntry: Codable {
        public let address: EthereumAddress
        public let storageKeys: [EthereumData]
    }
    
    public let accessList: [AccessListEntry]
    public let gasUsed: EthereumQuantity
    
    public init(accessList: [AccessListEntry], gasUsed: EthereumQuantity) {
        self.accessList = accessList
        self.gasUsed = gasUsed
    }
}

public extension EthereumAccessList {
    var asDictionary: OrderedDictionary<EthereumAddress, [EthereumData]> {
        var dict = OrderedDictionary<EthereumAddress, [EthereumData]>()
        for entry in accessList {
            dict[entry.address] = entry.storageKeys
        }
        return dict
    }
}
