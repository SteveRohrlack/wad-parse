//
//  WadLump.swift
//  wad-parse
//
//  Created by Steve Rohrlack on 03.08.18.
//

import Foundation

protocol WadLump {
    
    var offset: UInt32 { get }
    var size: UInt32 { get }
    var name: String { get }
    var categories: Set<WadLumpCategory> { get }
    
    init(offset: UInt32, size: UInt32, name: String, categories: Set<WadLumpCategory>)
    
    func readData(in wadData: Data) -> Data
    func including(categories: Set<WadLumpCategory>) -> WadLump
    
    func content(in wadData: Data) -> WadLumpContent?
    
}

extension WadLump {
    
    func readData(in wadData: Data) -> Data {
        let lumpAddress: Range<Int> = Int(offset)..<(Int(offset) + Int(size))
        return wadData.subdata(in: lumpAddress)
    }
    
    func including(categories newCategories: Set<WadLumpCategory>) -> WadLump {
        return Self.init(offset: offset, size: size, name: name, categories: categories.union(newCategories))
    }
    
}
