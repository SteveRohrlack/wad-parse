//
//  Data.swift
//  wad-parse
//
//  Created by Steve Rohrlack Digitalwert on 07.08.18.
//

import Foundation

extension Data {
    
    func intValue<T: FixedWidthInteger>(at address: Data.Index) -> T {
        let addressRange: Range<Int> = address..<(address + MemoryLayout<T>.size)
        
        return subdata(in: addressRange).withUnsafeBytes { $0.pointee } as T
    }
    
    func stringValue(at address: Data.Index, length: Int, encoding: String.Encoding = String.Encoding.ascii) -> String? {
        let addressRange: Range<Int> = address..<(address + length)
        
        return String(data: subdata(in: addressRange), encoding: encoding)
    }
    
}
