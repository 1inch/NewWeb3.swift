//
//  String+HexBytes.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//

import Foundation
import CryptoSwift

fileprivate let hexMapping: [String.Element: UInt8] = [
    "0": 0b0000,
    "1": 0b0001,
    "2": 0b0010,
    "3": 0b0011,
    "4": 0b0100,
    "5": 0b0101,
    "6": 0b0110,
    "7": 0b0111,
    "8": 0b1000,
    "9": 0b1001,

    "a": 0b1010,
    "b": 0b1011,
    "c": 0b1100,
    "d": 0b1101,
    "e": 0b1110,
    "f": 0b1111,

    "A": 0b1010,
    "B": 0b1011,
    "C": 0b1100,
    "D": 0b1101,
    "E": 0b1110,
    "F": 0b1111
]

extension String {

    /// Convert a hex string "0xFF" or "FF" to Bytes
    func hexBytes() throws -> Bytes {
        var string = self

        if string.count >= 2 {
            let pre = string.startIndex
            let post = string.index(string.startIndex, offsetBy: 2)
            if String(string[pre..<post]) == "0x" {
                // Remove prefix
                string = String(string[post...])
            }
        }

        // Check if we have a complete byte
        guard !string.isEmpty else {
            return Bytes()
        }

        //normalize string, since hex strings can omit leading 0
        string = string.count % 2 == 0 ? string : "0" + string

        return try string.rawHex()
    }

    func quantityHexBytes() throws -> Bytes {
        var bytes = Bytes()

        var string = self

        guard string.count >= 2 else {
            if string == "0" {
                return bytes
            }

            throw StringHexBytesError.hexStringMalformed
        }

        let pre = string.startIndex
        let post = string.index(string.startIndex, offsetBy: 2)
        if String(string[pre..<post]) == "0x" {
            // Remove prefix
            string = String(string[post...])
        }

        if string.count % 2 != 0 {
            let newStart = string.index(after: string.startIndex)

            guard let byte = Byte(String(string[string.startIndex]), radix: 16) else {
                throw StringHexBytesError.hexStringMalformed
            }
            bytes.append(byte)

            // Remove already appended byte so we have an even number of characters for the next step
            string = String(string[newStart...])
        }

        try bytes.append(contentsOf: string.rawHex())

        return bytes
    }

    private func rawHex() throws -> Bytes {
        // check if self is a valid hex string
        for char in self {
            if hexMapping[char] == nil {
                throw StringHexBytesError.hexStringMalformed
            }
        }
        return Array(hex: self)
    }
}

public enum StringHexBytesError: Error {

    case hexStringMalformed
}
