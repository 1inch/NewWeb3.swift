import Foundation
import BigInt
import CryptoSwift

public enum SolidityPacked {
    public enum SolidityError: Swift.Error {
        case invalidNumberType(type: String)
        case invalidBytesType(type: String)
        case invalidValueTypeForType(type: String, value: Any)
        case invalidArrayLength(type: String)
        case invalidType(type: String)
        case invalidValue(value: Any)
    }
    
    public enum BufferError: Swift.Error {
        case bufferOverrun(buffer: Data, length: Int, offset: Int)
    }
    
    public enum NumericError: Error {
        case tooLow(value: BigInt, width: BigInt)
        case tooHigh(value: BigInt, width: BigInt)
        case overflow(operation: String, fault: String, value: BigInt)
    }
    
    public static func solidityPacked(types: [String], values: [Any]) throws -> Data {
        guard types.count == values.count else {
            throw SolidityError.invalidArrayLength(type: "values")
        }
        
        let packedData = try zip(types, values)
            .map { (type, value) in
                try _pack(type: type, value: value)
            }
        
        return packedData.concat
    }
    
    public static func solidityPackedKeccak256(types: [String], values: [Any]) throws -> String {
        let packed = try solidityPacked(types: types, values: values)
        return "0x" + packed.sha3(.keccak256).toHexString()
    }
    
    public static func solidityPackedSha256(types: [String], values: [Any]) throws -> String {
        let packed = try solidityPacked(types: types, values: values)
        return "0x" + packed.sha256().toHexString()
    }
    
    private static let regexBytes = try! Regex("^bytes([0-9]+)$")
    private static let regexNumber = try! Regex("^(u?int)([0-9]*)$")
    private static let regexArray = try! Regex("^(.*)\\[([0-9]*)\\]$")
    
    private static func _pack(type: String, value: Any, isArray: Bool = false) throws -> Data {
        switch type {
        case "address":
            guard let stringValue = value as? String else {
                throw SolidityError.invalidValue(value: value)
            }
            
            let dataValue = Data(hex: stringValue)
            if isArray {
                return try dataValue.zeroPadValue(size: 32)
            }
            return dataValue
        case "string":
            guard let stringValue = value as? String else {
                throw SolidityError.invalidValue(value: value)
            }
            
            return stringValue.toUtf8Bytes
        case "bytes":
            guard
                let stringValue = value as? String
            else {
                throw SolidityError.invalidBytesType(type: type)
            }
            let data = Data(hex: stringValue)
            return data
        case "bool":
            guard let boolValue = value as? Bool else {
                throw SolidityError.invalidValue(value: value)
            }
            
            let boolStringValue = boolValue ? "0x01" : "0x00"
            let data = Data(hex: boolStringValue)
            return isArray ? try data.zeroPadValue(size: 32) : data
        default:
            break
        }
        
        if let match = try? regexNumber.firstMatch(in: type), match.count == 3 {
            let intTypePrefix = match[1].stringValue
            let intTypeSize = match[2].stringValue
            let signed = intTypePrefix == "int"
            
            let sizeString = (intTypeSize ?? "").isEmpty ? "256" : intTypeSize!
            guard
                let stringValue = value as? String,
                var bigIntValue = BigInt(solidityHex: stringValue),
                let size = Int(sizeString),
                size % 8 == 0,
                size != 0,
                size <= 256
            else {
                throw SolidityError.invalidNumberType(type: type)
            }
            
            let adjustedSize = isArray ? 256 : size
            if signed {
                bigIntValue = try bigIntValue.toTwos(width: adjustedSize)
            }
            return try bigIntValue.toData.zeroPadValue(size: adjustedSize / 8)
        }
        
        if let match = try? regexBytes.firstMatch(in: type), match.count == 2 {
            guard
                let stringValue = value as? String,
                let sizeString = match[1].stringValue,
                let size = Int(sizeString),
                size > 0,
                size <= 32
            else {
                throw SolidityError.invalidBytesType(type: type)
            }
            let data = Data(hex: stringValue)
            guard data.count == size else {
                throw SolidityError.invalidValueTypeForType(type: type, value: value)
            }
            return isArray ? try data.zeroPadBytes(size: 32) : data
        }
        
        if let match = try? regexArray.firstMatch(in: type), match.count == 3 {
            guard
                let baseType = match[1].stringValue,
                let arrayValue = value as? [Any]
            else {
                throw SolidityError.invalidType(type: type)
            }
            
            let count: Int
            if let countString = match[2].stringValue {
                if countString.isEmpty {
                    count = arrayValue.count
                }
                else if let _count = Int(countString) {
                    count = _count
                }
                else {
                    throw SolidityError.invalidArrayLength(type: type)
                }
            }
            else {
                count = arrayValue.count
            }
            
            guard count == arrayValue.count else {
                throw SolidityError.invalidArrayLength(type: type)
            }
            let packedArray = try arrayValue.map { try _pack(type: baseType, value: $0, isArray: true) }
            return packedArray.concat
        }
        
        throw SolidityError.invalidType(type: type)
    }
}

private extension Data {
    func zeroPadValue(size: Int) throws -> Data {
        try _zeroPad(length: size, left: true)
    }
    
    func zeroPadBytes(size: Int) throws -> Data {
        try _zeroPad(length: size, left: false)
    }
    
    func _zeroPad(length: Int, left: Bool) throws -> Data {
        guard length >= count else {
            throw SolidityPacked.BufferError.bufferOverrun(buffer: self, length: length, offset: length + 1)
        }
        
        var result = Data(count: length)
        if left {
            result.replaceSubrange(length - count..<length, with: self)
        } else {
            result.replaceSubrange(0..<count, with: self)
        }
        
        return result
    }
}

private extension AnyRegexOutput.Element {
    var stringValue: String? {
        substring.map(String.init)
    }
}

private extension BigInt {
    init?(solidityHex: String) {
        if solidityHex.hasPrefix("-") {
            let raw = "-" + String(solidityHex.dropFirst()).drop0x
            self.init(raw, radix: 16)
        }
        else {
            self.init(solidityHex.drop0x, radix: 16)
        }
    }
    
    /// Converts value to a Big Endian Data
    var toData: Data {
        if self == 0 {
            return Data()
        }
        
        var hex = String(self, radix: 16)
        
        if hex.count % 2 != 0 {
            hex = "0" + hex
        }
        
        var result = Data(capacity: hex.count / 2)
        
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            if let byte = UInt8(hex[index..<nextIndex], radix: 16) {
                result.append(byte)
            }
            index = nextIndex
        }
        
        return result
    }
    
    func toTwos(width: Int) throws -> BigInt {
        let widthBigInt = BigInt(width)
        let limit = BigInt(1) << (widthBigInt - 1)
        
        if self < 0 {
            let absoluteValue = -self
            if absoluteValue > limit {
                throw SolidityPacked.NumericError.tooLow(value: self, width: widthBigInt)
            }
            let mask = (BigInt(1) << widthBigInt) - 1
            return ((~absoluteValue) & mask) + 1
        } else {
            if self >= limit {
                throw SolidityPacked.NumericError.tooHigh(value: self, width: widthBigInt)
            }
        }
        
        return self
    }
}

private extension String {
    var toUtf8Bytes: Data {
        data(using: .utf8)!
    }
    
    var drop0x: String {
        if hasPrefix("0x") {
            String(dropFirst(2))
        }
        else {
            self
        }
    }
}

private extension Array where Element == Data {
    var concat: Data {
        reduce(Data(), +)
    }
}
